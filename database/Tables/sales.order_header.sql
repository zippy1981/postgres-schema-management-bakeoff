CREATE TABLE sales.order_header (
    order_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id integer NOT NULL REFERENCES sales.customer (customer_id),
    order_date date NOT NULL,
    status text NOT NULL DEFAULT 'new'
);
