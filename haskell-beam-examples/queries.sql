-- Fetch all columns from the customer table
SELECT * FROM customer;

-- Fetch only the first name and email of customers
SELECT first_name, email FROM customer;

-- Fetch customers who have 'Doe' as their last name
SELECT * FROM customer WHERE last_name = 'Doe';

-- Fetch all products ordered by price in descending order
SELECT * FROM product ORDER BY price DESC;

-- Fetch the top 5 most expensive products
SELECT * FROM product ORDER BY price DESC LIMIT 5;

-- Fetch the total number of orders for each customer
SELECT customer_id, COUNT(order_id) AS order_count
FROM "order"
GROUP BY customer_id;

-- union/intersect

-- Find customers who have placed orders worth more than $500
SELECT first_name, last_name
FROM customer
WHERE customer_id IN (
    SELECT customer_id
    FROM "order"
    WHERE total_amount > 500
);

-- Get a list of all orders with customer names and product details
SELECT o.order_id, c.first_name, c.last_name, p.product_name, oi.quantity, oi.unit_price
FROM "order" o
JOIN customer c ON o.customer_id = c.customer_id
JOIN order_item oi ON o.order_id = oi.order_id
JOIN product p ON oi.product_id = p.product_id;


-- Use a CTE to get the total amount spent by each customer and then fetch those who spent more than $1000
WITH customer_spending AS (
    SELECT customer_id, SUM(total_amount) AS total_spent
    FROM "order"
    GROUP BY customer_id
)
SELECT c.customer_id, c.first_name, c.last_name, cs.total_spent
FROM customer c
JOIN customer_spending cs ON c.customer_id = cs.customer_id
WHERE cs.total_spent > 1000;


SELECT c.customer_id, c.first_name, c.last_name, o.order_id, o.total_amount
FROM customer c
LEFT JOIN "order" o ON c.customer_id = o.customer_id;

-- Calculate the total amount spent by each customer and rank them
SELECT customer_id, SUM(total_amount) AS total_spent,
       RANK() OVER (ORDER BY SUM(total_amount) DESC) AS rank
FROM "order"
GROUP BY customer_id;

-- Fetch orders with customer details where the total amount is greater than $500
SELECT o.order_id, o.total_amount, c.first_name, c.last_name
FROM "order" o
JOIN customer c ON o.customer_id = c.customer_id
WHERE o.total_amount > 500;