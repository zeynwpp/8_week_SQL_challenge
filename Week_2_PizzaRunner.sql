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
select DATEPART(hour, c.order_time) as order_hour,
count(c.pizza_id) as pizza_count
from pizza_runner.customer_orders c
group by DATEPART(hour, c.order_time)



--What was the volume of orders for each day of the week?
select DATENAME(WEEKDAY, c.order_time) as order_day,
count(c.order_id) as order_count
from pizza_runner.customer_orders c
group by  DATENAME(WEEKDAY, c.order_time) 


--B. Runner and Customer Experience
--How many runners signed up for each 1 week period? (i.e. week starts 2021-01-01)
DECLARE @startdate date 
set @startdate = (
select min(registration_date) from runners
)

select datediff(week, @startdate, registration_date) + 1 as week_number
,COUNT(*) as runners_signed_Up
from runners
group by datediff(week, @startdate, registration_date)
ORDER by week_number


--What was the average time in minutes it took for each runner to arrive at the Pizza Runner HQ to pickup the order?
with cleaned_data as (SELECT runner_id, 
cast(
	replace(
      replace(
        replace(r.duration, 'minutes', ''), 'minute', ''), 'mins', '') as INT 
) as duration_int
FROM runner_orders r
WHERE duration IS NOT NULL AND duration NOT IN ('', 'null'))

select c.runner_id
,avg(c.duration_int)
from cleaned_data c
group by c.runner_id


--Is there any relationship between the number of pizzas and how long the order takes to prepare?



--What was the average distance travelled for each customer?
--What was the difference between the longest and shortest delivery times for all orders?
--What was the average speed for each runner for each delivery and do you notice any trend for these values?
--What is the successful delivery percentage for each runner?
