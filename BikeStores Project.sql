SELECT s.store_id, s.store_name, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.orders o
JOIN sales.order_items oi ON o.order_id = oi.order_id
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.store_id, s.store_name

SELECT product_id, product_name, brand_name, total_quantity_sold
FROM (
    SELECT p.product_id, p.product_name, b.brand_name,
           SUM(oi.quantity) AS total_quantity_sold,
           ROW_NUMBER() OVER (ORDER BY SUM(oi.quantity) DESC) AS row_num
    FROM production.products p
    JOIN production.brands b ON p.brand_id = b.brand_id
    JOIN sales.order_items oi ON p.product_id = oi.product_id
    GROUP BY p.product_id, p.product_name, b.brand_name
) AS ranked_products
WHERE row_num <= 5

SELECT s.staff_id, s.first_name, s.last_name, COUNT(o.order_id) AS total_sales
FROM sales.staffs s
JOIN sales.orders o ON s.staff_id = o.staff_id
GROUP BY s.staff_id, s.first_name, s.last_name
ORDER BY total_sales DESC

SELECT b.brand_id, b.brand_name, SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM production.products p
JOIN production.brands b ON p.brand_id = b.brand_id
JOIN sales.order_items oi ON p.product_id = oi.product_id
GROUP BY b.brand_id, b.brand_name

SELECT s.city, COUNT(o.order_id) AS total_orders
FROM sales.orders o
JOIN sales.stores s ON o.store_id = s.store_id
GROUP BY s.city

SELECT AVG(quantity) AS average_quantity_per_order
FROM sales.order_items

SELECT c.customer_id, c.first_name, c.last_name, COUNT(o.order_id) AS total_orders_placed
FROM sales.customers c
JOIN sales.orders o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders_placed DESC