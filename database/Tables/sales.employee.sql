CREATE TABLE sales.employee (
    employee_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name text NOT NULL,
    department_id integer NOT NULL
);
