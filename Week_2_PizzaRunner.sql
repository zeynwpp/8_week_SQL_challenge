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



--For each customer, how many delivered pizzas had at least 1 change and how many had no changes?
--How many pizzas were delivered that had both exclusions and extras?
--What was the total volume of pizzas ordered for each hour of the day?
--What was the volume of orders for each day of the week?
