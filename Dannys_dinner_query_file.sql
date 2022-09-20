
-- Creating the Schema
CREATE DATABASE dannys_dinner;
USE dannys_dinner;

-- Created the 3 Tables.
CREATE TABLE sales (
    customer_id VARCHAR(1),
    order_date DATE,
    product_id INT
);

CREATE TABLE menu (
    product_id INT,
    product_name VARCHAR(25),
    price INT
);

CREATE TABLE members (
    customer_id VARCHAR(1),
    join_date DATE
);


-- Inserting into those tables
INSERT INTO sales VALUES
  ('A', '2021-01-01', '1'),
  ('A', '2021-01-01', '2'),
  ('A', '2021-01-07', '2'),
  ('A', '2021-01-10', '3'),
  ('A', '2021-01-11', '3'),
  ('A', '2021-01-11', '3'),
  ('B', '2021-01-01', '2'),
  ('B', '2021-01-02', '2'),
  ('B', '2021-01-04', '1'),
  ('B', '2021-01-11', '1'),
  ('B', '2021-01-16', '3'),
  ('B', '2021-02-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-01', '3'),
  ('C', '2021-01-07', '3');
  
  INSERT INTO menu VALUES
  ('1', 'sushi', '10'),
  ('2', 'curry', '15'),
  ('3', 'ramen', '12');
  
  INSERT INTO members VALUES
    ('A', '2021-01-07'),
    ('B', '2021-01-09');
    

-- Querys for the answer
    
-- 1. What is the total amount each customer spent at the restaurant?
SELECT s.customer_id, SUM(m.price)
FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY 1;

-- 2. How many days has each customer visited the restaurant?
SELECT s.customer_id, COUNT(DISTINCT(s.order_date)) AS visited_days
FROM sales s
GROUP BY 1;

-- 3. What was the first item from the menu purchased by each customer?
SELECT s.customer_id, MIN(s.order_date), m.product_name
FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY 1;

-- 4. What is the most purchased item on the menu and how many times was it purchased by all customers?
SELECT m.product_name, COUNT(s.product_id) AS product_count
FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

-- 5. Which item was the most popular for each customer?
SELECT customer_id, product_name
FROM
(SELECT s.customer_id,
	   m.product_name,
       COUNT(s.product_id) AS order_count,
       DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY COUNT(s.customer_id)DESC) AS item_rank
FROM sales s
JOIN menu m ON m.product_id = s.product_id
GROUP BY 1,2) t
WHERE item_rank = 1;

-- 6. Which item was purchased first by the customer after they became a member?
SELECT customer_id, join_date, order_date, first_order
FROM
(SELECT s.customer_id, s.order_date, s.product_id, mem.join_date, m.product_name AS first_order,
	   DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_member
FROM sales s
JOIN members mem ON mem.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date >= mem.join_date) x

WHERE rank_member = 1;

-- 7. Which item was purchased just before the customer became a member?
SELECT customer_id, join_date, order_date, first_order
FROM
(SELECT s.customer_id, s.order_date, s.product_id, mem.join_date, m.product_name AS first_order,
	   DENSE_RANK() OVER(PARTITION BY s.customer_id ORDER BY s.order_date) AS rank_member
FROM sales s
JOIN members mem ON mem.customer_id = s.customer_id
JOIN menu m ON m.product_id = s.product_id
WHERE s.order_date < mem.join_date) x

WHERE rank_member = 1;

-- 8. What is the total items and amount spent for each member before they became a member?
SELECT 
    s.customer_id,
    mbr.join_date,
    COUNT(s.product_id) AS total_products,
    SUM(m.price) AS amount_spent
FROM
    sales s
        JOIN
    menu m ON m.product_id = s.product_id
        JOIN
    members mbr ON mbr.customer_id = s.customer_id
WHERE
    s.order_date < mbr.join_date
GROUP BY 1;

-- 9. If each $1 spent equates to 10 points and sushi has a 2x points multiplier - how many points would each customer have?

SELECT 
    s.customer_id, SUM(total_points) AS POINTS
FROM
    (SELECT 
        *,
            CASE
                WHEN product_name = 'sushi' THEN price * 20
                ELSE price * 10
            END AS total_points
    FROM
        menu) x
        JOIN
    sales s ON s.product_id = x.product_id
GROUP BY 1;

-- 10, In the first week after a customer joins the program (including their join date) they earn 2x points on all items,
-- not just sushi - how many points do customer A and B have at the end of January? 

SELECT 
    x.customer_id,
    x.join_date,
    x.first_week,
    SUM(CASE
        WHEN
            s.order_date BETWEEN x.join_date AND x.first_week
                AND m.product_name = 'sushi'
        THEN
            m.price * 0
        WHEN s.order_date BETWEEN x.join_date AND x.first_week THEN m.price * 20
        ELSE m.price * 10
    END) AS points
FROM
    (SELECT 
        *,
            ADDDATE(join_date, INTERVAL 6 DAY) AS first_week,
            LAST_DAY(join_date) AS month_end
    FROM
        members) x
        JOIN
    sales s ON s.customer_id = x.customer_id
        JOIN
    menu m ON m.product_id = s.product_id
WHERE
    s.order_date <= x.month_end
GROUP BY 1;

