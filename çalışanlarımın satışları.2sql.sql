--çalışanlarımın satışları
WITH employee_orders AS (
    SELECT o.employee_id,
           od.product_id,
           COUNT(od.product_id) AS product_count,
           RANK() OVER (PARTITION BY o.employee_id ORDER BY COUNT(od.product_id) DESC) AS rank_most,
           RANK() OVER (PARTITION BY o.employee_id ORDER BY COUNT(od.product_id) ASC) AS rank_least
    FROM employees AS e
    JOIN orders AS o ON e.employee_id = o.employee_id
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.employee_id, od.product_id
)
SELECT 
       CONCAT(e.first_name, ' ', e.last_name) AS employee_name,  -- Çalışan ismini birleştiriyoruz
       COUNT(DISTINCT o.order_id) AS order_count,  -- Sipariş sayısı
       MAX(CASE WHEN eo.rank_most = 1 THEN p.product_name END) AS most_sold_product_name,  -- En çok satılan ürün adı
       MAX(CASE WHEN eo.rank_most = 1 THEN eo.product_count END) AS most_sold_product_count, -- En çok satılan ürün adedi
       MAX(CASE WHEN eo.rank_least = 1 THEN p.product_name END) AS least_sold_product_name,  -- En az satılan ürün adı
       MAX(CASE WHEN eo.rank_least = 1 THEN eo.product_count END) AS least_sold_product_count -- En az satılan ürün adedi
FROM employee_orders eo
JOIN orders AS o ON eo.employee_id = o.employee_id
JOIN products AS p ON eo.product_id = p.product_id
JOIN employees AS e ON eo.employee_id = e.employee_id  -- Çalışan adını ekliyoruz
GROUP BY e.first_name, e.last_name
ORDER BY order_count DESC;
