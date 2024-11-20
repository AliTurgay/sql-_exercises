--rfm

WITH customer_rfm AS (
    SELECT 
        o.customer_id, 
        MAX(o.order_date) AS last_order_date,  -- Recency: En son sipariş tarihi
        COUNT(o.order_id) AS frequency,        -- Frequency: Sipariş sayısı
        SUM(od.unit_price * od.quantity * (1 - od.discount)) AS monetary -- Monetary: Toplam harcama
    FROM orders AS o
    JOIN order_details AS od ON o.order_id = od.order_id
    GROUP BY o.customer_id
)
SELECT 
    customer_id,
    EXTRACT(DAY FROM AGE(CURRENT_DATE, last_order_date)) AS recency,  -- İki tarih arasındaki farkı gün olarak hesapla
    frequency,
    TO_CHAR(monetary, 'FM999,999,999,999.00') AS monetary             -- Toplam harcamayı formatla
FROM customer_rfm
ORDER BY recency ASC, frequency DESC, monetary DESC;
