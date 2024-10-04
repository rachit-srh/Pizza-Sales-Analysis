CREATE TABLE orders(
	order_id INTEGER PRIMARY KEY,
	order_date DATE,
	order_time TIME
);

CREATE TABLE order_details(
	order_details_id INTEGER PRIMARY KEY,
	order_id INTEGER,
	pizza_id TEXT,
	quantity INTEGER
);

CREATE TABLE pizzas(
	pizza_id TEXT PRIMARY KEY,
	pizza_type_id TEXT,
	size TEXT,
	price NUMERIC
);

CREATE TABLE pizza_types(
	pizza_type_id TEXT PRIMARY KEY,
	pizza_name TEXT,
	category TEXT,
	ingredients TEXT
);

COPY order_details(order_details_id,order_id,pizza_id,quantity)
FROM 'C:\SQL\pizza_sales\order_details.csv'
DELIMITER ','
CSV  HEADER

COPY orders(order_id,order_date,order_time)
FROM 'C:\SQL\pizza_sales\orders.csv'
DELIMITER ','
CSV  HEADER

COPY pizza_types(pizza_type_id,pizza_name,category,ingredients)
FROM 'C:\SQL\pizza_sales\pizza_types.csv'
DELIMITER ','
CSV  HEADER

COPY pizzas(pizza_id,pizza_type_id,size,price)
FROM 'C:\SQL\pizza_sales\pizzas.csv'
DELIMITER ','
CSV  HEADER


