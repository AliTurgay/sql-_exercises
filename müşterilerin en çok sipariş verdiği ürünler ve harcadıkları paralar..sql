--müşterilerin en çok sipariş verdiği ürünler ve harcadıkları paralar.



WITH customer_orders AS (
    SELECT 
        c.customer_id,
        COUNT(DISTINCT o.order_id) AS total_orders,
        SUM(od.unit_price * od.quantity) AS total_spent
    FROM 
        orders AS o
    JOIN customers AS c ON o.customer_id = c.customer_id
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY 
        c.customer_id
),
most_purchased_products AS (
    SELECT 
        c.customer_id,
        p.product_name,
        SUM(od.quantity) AS total_quantity,
        ROW_NUMBER() OVER (PARTITION BY c.customer_id ORDER BY SUM(od.quantity) DESC) AS rank
    FROM 
        orders AS o
    JOIN customers AS c ON o.customer_id = c.customer_id
    JOIN order_details AS od ON o.order_id = od.order_id
    JOIN products AS p ON od.product_id = p.product_id
    GROUP BY 
        c.customer_id, 
        p.product_name
)
SELECT 
    co.customer_id,
    co.total_orders,
    TO_CHAR(co.total_spent, 'FM999G999G999D00') AS total_spent,
    mpp.product_name AS most_purchased_product
FROM 
    customer_orders AS co
LEFT JOIN most_purchased_products AS mpp 
    ON co.customer_id = mpp.customer_id AND mpp.rank = 1
ORDER BY 
    co.total_orders DESC;

