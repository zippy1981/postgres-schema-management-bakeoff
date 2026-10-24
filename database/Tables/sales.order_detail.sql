CREATE TABLE sales.order_detail (
    order_detail_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_id integer NOT NULL REFERENCES sales.order_header (order_id),
    product_id integer NOT NULL REFERENCES inventory.product (product_id),
    quantity integer NOT NULL CHECK (quantity > 0),
    unit_price numeric(12, 2) NOT NULL CHECK (unit_price >= 0)
);
