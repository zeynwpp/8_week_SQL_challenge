--A. Pizza Metrics
--How many pizzas were ordered?
select COUNT(o.order_id) as order_count
from pizza_runner.customer_orders o

--How many unique customer orders were made?
select count(distinct c.customer_id) as unique_orders
from pizza_runner.customer_orders c

--How many successful orders were delivered by each runner?
select r.runner_id
,count(r.order_id) as succesful_order
from pizza_runner.runner_orders r
where r.cancellation is null
group by r.runner_id


--How many of each type of pizza was delivered?
select p.pizza_name
,count(c.order_id) as orders
from pizza_runner.customer_orders c
inner join pizza_runner.pizza_names p on p.pizza_id = c.pizza_id
group by p.pizza_name

--How many Vegetarian and Meatlovers were ordered by each customer?
select p.pizza_name
,c.customer_id
,count(c.order_id) as orders
from pizza_runner.customer_orders c
inner join pizza_runner.pizza_names p on p.pizza_id = c.pizza_id
group by p.pizza_name, c.customer_id


--What was the maximum number of pizzas delivered in a single order?
select max(z.count_order) as max_order
from (
	select count(c.pizza_id) as count_order
	from pizza_runner.customer_orders c
	group by c.order_id
) z


--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
select c.customer_id
,count(case when c.exclusions is null or c.extras is not null then c.pizza_id end) as changed_pizza
,count(case when c.exclusions is null and c.extras is null then c.pizza_id end) as no_change_pizza
from pizza_runner.customer_orders c
inner join pizza_runner.runner_orders r on r.order_id = c.order_id
where r.cancellation is null
group by c.customer_id



--How many pizzas were delivered that had both exclusions and extras?
select COUNT(c.pizza_id) as result
from pizza_runner.customer_orders c
inner join pizza_runner.runner_orders r on r.order_id = c.order_id
where c.exclusions is not null
and c.extras is not null
and r.cancellation is null


--What was the total volume of pizzas ordered for each hour of the day?




--What was the volume of orders for each day of the week?


