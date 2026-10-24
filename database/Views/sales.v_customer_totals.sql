CREATE VIEW sales.v_customer_totals AS
SELECT
    customer_name,
    SUM(line_total) AS total_amount
FROM sales.v_order_detail
GROUP BY customer_name;
