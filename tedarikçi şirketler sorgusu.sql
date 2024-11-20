-- her tedarikçi firmanın bana ne kadar ürün sattırdıgını ve ne kadar gelir getirdiğini sağla 
-- ve yıllara göre ayır.
	
	SELECT
    s.company_name,
    EXTRACT(YEAR FROM o.order_date) AS year,
    TO_CHAR(SUM(p.unit_price * od.quantity), 'FM999G999G999D00') AS total_revenue,
    COUNT(DISTINCT od.order_id) AS total_orders
FROM
    products AS p
JOIN suppliers AS s ON p.supplier_id = s.supplier_id
JOIN order_details AS od ON od.product_id = p.product_id
JOIN orders AS o ON o.order_id = od.order_id
GROUP BY
    s.company_name,
    EXTRACT(YEAR FROM o.order_date)
ORDER BY
    total_orders DESC;

