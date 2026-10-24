CREATE VIEW sales.v_order_detail AS
SELECT
    oh.order_id,
    oh.order_date,
    c.name AS customer_name,
    p.sku,
    od.quantity,
    od.unit_price,
    od.quantity * od.unit_price AS line_total
FROM sales.order_header AS oh
INNER JOIN sales.customer AS c ON oh.customer_id = c.customer_id
INNER JOIN sales.order_detail AS od ON oh.order_id = od.order_id
INNER JOIN inventory.product AS p ON od.product_id = p.product_id;
