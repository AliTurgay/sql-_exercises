-- ülkelerin yıllara göre aldığı ürünler ve gelirler
WITH country_revenue AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_date) AS year,
        o.ship_country,
        COUNT(o.order_id) AS order_count,
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS total_spent
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY year, o.ship_country
),
product_sales AS (
    SELECT 
        EXTRACT(YEAR FROM o.order_date) AS year,
        o.ship_country,
        od.product_id,
        SUM(od.quantity) AS total_quantity,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM o.order_date), o.ship_country ORDER BY SUM(od.quantity) DESC) AS rank_most,
        RANK() OVER (PARTITION BY EXTRACT(YEAR FROM o.order_date), o.ship_country ORDER BY SUM(od.quantity) ASC) AS rank_least
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY year, o.ship_country, od.product_id
)
SELECT 
    cr.year,
    cr.ship_country,
    cr.order_count,
    TO_CHAR(cr.total_spent, 'FM999,999,999,999.00') AS total_spent,
    MAX(CASE WHEN ps.rank_most = 1 THEN p.product_name END) AS most_sold_product,
    MAX(CASE WHEN ps.rank_least = 1 THEN p.product_name END) AS least_sold_product
FROM country_revenue cr
LEFT JOIN product_sales ps ON cr.year = ps.year AND cr.ship_country = ps.ship_country
LEFT JOIN products p ON ps.product_id = p.product_id
GROUP BY cr.year, cr.ship_country, cr.order_count, cr.total_spent
ORDER BY cr.year DESC, cr.total_spent DESC;


