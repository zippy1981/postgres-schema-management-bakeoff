CREATE TABLE sales.department (
    department_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL UNIQUE,
    manager_id integer NULL
);
