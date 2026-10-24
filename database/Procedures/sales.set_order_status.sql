CREATE PROCEDURE sales.set_order_status(p_order_id integer, p_status text)
LANGUAGE plpgsql
AS $$
BEGIN
    UPDATE sales.order_header
    SET status = p_status
    WHERE order_id = p_order_id;

    INSERT INTO audit.change_log (table_name, row_key, changed_by)
    VALUES ('sales.order_header', p_order_id::text, current_user);
END;
$$;
