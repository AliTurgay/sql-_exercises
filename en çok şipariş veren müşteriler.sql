SELECT c.customer_id,
COUNT(o.order_id) as total_orders
FROM orders as o
JOIN customers as c ON o.customer_id = c.customer_id
GROUP BY c.customer_id
order by total_orders desc
