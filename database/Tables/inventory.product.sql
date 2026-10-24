CREATE TABLE inventory.product (
    product_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_id integer NOT NULL REFERENCES inventory.category (category_id),
    sku text NOT NULL UNIQUE,
    name text NOT NULL,
    unit_price numeric(12, 2) NOT NULL CHECK (unit_price >= 0)
);
