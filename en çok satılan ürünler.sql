select p.product_name,
count(o.order_id) as total_sales
from orders as o
join order_details as od on o.order_id = od.order_id
join products as p on od.product_id = p.product_id
group by p.product_name
order by total_sales desc

