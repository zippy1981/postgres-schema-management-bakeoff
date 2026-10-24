CREATE TABLE inventory.category (
    category_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    parent_id integer NULL REFERENCES inventory.category (category_id),
    name text NOT NULL
);
