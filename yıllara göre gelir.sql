SELECT EXTRACT(YEAR FROM o.order_date) AS order_year,
       TO_CHAR(SUM(od.unit_price * od.quantity * (1 - od.discount)), 'FM999,999,999,999.00') AS formatted_total_revenue
FROM orders AS o
JOIN order_details AS od ON o.order_id = od.order_id
GROUP BY order_year
ORDER BY order_year;
