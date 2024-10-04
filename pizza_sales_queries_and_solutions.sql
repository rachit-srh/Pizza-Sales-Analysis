SELECT * FROM orders
SELECT * FROM order_details
SELECT * FROM pizzas
SELECT * FROM pizza_types

-- BASIC QUERIES
--1.	Retrieve the total number of orders placed. 
SELECT COUNT(order_id) AS total_orders FROM orders

--2.	Calculate the total revenue generated from pizza sales.
SELECT SUM(od.quantity*p.price) AS revenue
	FROM order_details od
	JOIN pizzas p
	ON od.pizza_id = p.pizza_id

--3.	Identify the highest-priced pizza.
SELECT DISTINCT pt.pizza_name AS highest_price_pizza, p.price  AS price
	FROM pizza_types pt
	JOIN pizzas p
	ON pt.pizza_type_id = p.pizza_type_id
	ORDER BY p.price DESC
	LIMIT 1

--4.	Identify the most common pizza size ordered.
SELECT p.size AS most_common_pizza_size, SUM(od.quantity) AS quantity
	FROM pizzas p
	JOIN order_details od
	ON p.pizza_id = od.pizza_id
	GROUP BY p.size
	ORDER BY quantity DESC
	LIMIT 1

--5.	List the top 5 most ordered pizza types along with their quantities.
SELECT p.pizza_type_id ,SUM(od.quantity) AS quantity
	FROM pizzas p
	JOIN order_details od
	ON p.pizza_id = od.pizza_id
	GROUP BY p.pizza_type_id
	ORDER BY quantity DESC
	LIMIT 5

-- INTERMEDIATE QUERIES
--1.	Join the necessary tables to find the total quantity of each pizza category ordered.
SELECT  pt.category, SUM(od.quantity) AS quantity
	FROM order_details od
	JOIN pizzas p
	ON od.pizza_id = p.pizza_id
	JOIN pizza_types pt
	ON p.pizza_type_id = pt.pizza_type_id
GROUP BY pt.category

--2.	Determine the distribution of orders by hour of the day.
SELECT EXTRACT(HOUR FROM order_time) AS hour, COUNT(order_id) AS order_count
	FROM orders
	GROUP BY EXTRACT(HOUR FROM order_time)
	ORDER BY hour

--3.	Find the category-wise distribution of pizzas.
SELECT category, COUNT(pizza_name) pizza_count
	FROM pizza_types
	GROUP BY category

--4.	Group the orders by date and calculate the average number of pizzas ordered per day.
SELECT ROUND(AVG(total_quantity), 0) AS avg_pizzas_ordered_per_day
	FROM
	(SELECT DISTINCT o.order_date, SUM(od.quantity) AS total_quantity
	FROM orders o
	JOIN order_details od
	ON o.order_id = od.order_id
	GROUP BY o.order_date) AS order_quantity

--5.	Determine the top 3 most ordered pizza types based on revenue.
SELECT pt.pizza_name, SUM(od.quantity*p.price) AS revenue
	FROM pizza_types pt
	JOIN pizzas p
	ON p.pizza_type_id = pt.pizza_type_id
	JOIN order_details od
	ON p.pizza_id = od.pizza_id
	GROUP BY pt.pizza_name
	ORDER BY revenue DESC
	LIMIT 3

--ADVANCE QUERIES
--1.	Calculate the percentage contribution of each pizza type to total revenue.
SELECT pt.pizza_name, ROUND(SUM(od.quantity*p.price)/
		(SELECT SUM(od.quantity*p.price)
			FROM order_details od
			JOIN pizzas p
			ON od.pizza_id = p.pizza_id) * 100, 2) AS percentage
	FROM pizza_types pt
	JOIN pizzas p
	ON pt.pizza_type_id = p.pizza_type_id
	JOIN order_details od
	ON od.pizza_id = p.pizza_id
	GROUP BY pt.pizza_name
	ORDER BY percentage DESC
	
--2.	Analyse the cumulative revenue generated over time.
SELECT order_date,
	SUM(revenue) OVER(ORDER BY order_date) AS cum_revenue
	FROM
	(SELECT o.order_date, SUM(od.quantity*p.price) AS revenue
		FROM orders o
		JOIN order_details od
		ON o.order_id = od.order_id
		JOIN pizzas p
		ON od.pizza_id = p.pizza_id
		GROUP BY order_date) AS rev

--3.	Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT category, pizza_name, revenue, rank
	FROM
	(SELECT category, pizza_name, revenue, RANK() OVER(PARTITION BY category ORDER BY revenue DESC) AS rank
	FROM
		(SELECT pt.category, pt.pizza_name,ROUND(SUM(od.quantity*p.price)) AS revenue
			FROM pizza_types pt
			JOIN pizzas p
			ON pt.pizza_type_id = p.pizza_type_id
			JOIN order_details od
			ON p.pizza_id = od.pizza_id
			GROUP BY category, pizza_name
			ORDER BY category, pizza_name) AS rev) AS rk
	WHERE rank <= 3



