/* --------------------
   Case Study Questions
   --------------------*/

-- 1. What is the total amount each customer spent at the restaurant?
select t.customer_id
, sum(t.price)
from dannys_diner.members mb
inner join (
select m.product_id
, s.customer_id
, m.price
from dannys_diner.menu m
inner join dannys_diner.sales s on s.product_id = m.product_id 
) t on t.customer_id = mb.customer_id
group by t.customer_id

-- 2. How many days has each customer visited the restaurant?
select s.customer_id
, count(distinct s.order_date) as Count_of_Visit
from dannys_diner.sales s
group by s.customer_id

-- 3. What was the first item from the menu purchased by each customer?
select distinct ss.customer_id
,m.product_name
from dannys_diner.sales ss
inner join dannys_diner.menu m on m.product_id = ss.product_id
inner join (
    SELECT s.customer_id
	,MIN(s.order_date) as min_date
    FROM dannys_diner.sales s
	group by s.customer_id
) t on t.min_date = ss.order_date


-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
select m.product_name
,count(*) as sum_purchased
from dannys_diner.sales s
inner join dannys_diner.menu m on m.product_id = s.product_id
group by m.product_name


-- 5. Which item was the most popular for each customer?
with purchase_count as (
    select
        s.customer_id,
        s.product_id,
        COUNT(*) AS order_count,
        DENSE_RANK() OVER (PARTITION BY s.customer_id ORDER BY COUNT(*) desc) AS rnk
    from dannys_diner.sales s
    group by s.customer_id, s.product_id
)

select pc.customer_id, 
       m.product_name, 
       pc.order_count
from purchase_count pc
INNER JOIN dannys_diner.menu m on m.product_id = pc.product_id  
where pc.rnk = 1; 

-- 6. Which item was purchased first by the customer after they became a member?

with after_member_orders as(
select m.customer_id
,mn.product_name
,s.order_date
from dannys_diner.members m
inner join dannys_diner.sales s on s.customer_id = m.customer_id
inner join dannys_diner.menu mn on mn.product_id = s.product_id
where s.order_date >= m.join_date
), 
ranked_orders as (
select a.customer_id
,a.product_name
,row_number() over(partition by a.customer_id order by a.order_date ) as rank_
from after_member_orders a
)
select r.customer_id
,r.product_name
from ranked_orders r
where r.rank_ = 1



-- 7. Which item was purchased just before the customer became a member?

with before_member_orders as(
select m.customer_id
,mn.product_name
,s.order_date
from dannys_diner.members m
inner join dannys_diner.sales s on s.customer_id = m.customer_id
inner join dannys_diner.menu mn on mn.product_id = s.product_id
where s.order_date < m.join_date
), 
ranked_orders as (
select a.customer_id
,a.product_name
,row_number() over(partition by a.customer_id order by a.order_date desc) as rank_
from before_member_orders a
)

select r.customer_id
,r.product_name
from ranked_orders r
where r.rank_ = 1


-- 8. What is the total items and amount spent for each member before they became a member?
select mb.customer_id
,m.product_name
,sum(m.price) as amount_spent
from dannys_diner.menu m
inner join dannys_diner.sales s on s.product_id = m.product_id
inner join dannys_diner.members mb on mb.customer_id = s.customer_id
where s.order_date < mb.join_date
group by mb.customer_id
,m.product_name


-- 9.  If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

with points_table as (
select mb.customer_id
,m.product_name
,sum(m.price) *
case when m.product_name = 'sushi' then 20 
	else 10
	end as Points
from dannys_diner.menu m
inner join dannys_diner.sales s on s.product_id = m.product_id
inner join dannys_diner.members mb on mb.customer_id = s.customer_id
where s.order_date < mb.join_date
group by mb.customer_id
,m.product_name)

select p.customer_id
,sum(p.points) as sum_points
from points_table p
group by p.customer_id


-- 10. In the first week after a customer joins the program (including their join date) they earn 2x points on all items, not just sushi - how many points do customer A and B have at the end of January?
with points_table as (
   select
        s.customer_id,
        m.product_name,
        SUM(m.price * 
		 case when DATEDIFF(day, mb.join_date, s.order_date) BETWEEN 0 AND 6 THEN 20  
            when m.product_name = 'sushi' THEN 20  -- Sushi için 2x puan (10 yerine 20)
            else 10  -- Diğerleri normal puan
        end) as total_points
    FROM dannys_diner.sales s
    INNER JOIN dannys_diner.menu m ON s.product_id = m.product_id
    INNER JOIN dannys_diner.members mb ON s.customer_id = mb.customer_id
    WHERE s.order_date <= '20210131'
    GROUP BY s.customer_id, m.product_name
)
select customer_id, SUM(total_points) as total_points
from points_table
group by customer_id

