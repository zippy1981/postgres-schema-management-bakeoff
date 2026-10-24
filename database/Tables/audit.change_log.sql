CREATE TABLE audit.change_log (
    change_id integer GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    table_name text NOT NULL,
    row_key text NOT NULL,
    changed_at timestamptz NOT NULL DEFAULT NOW(),
    changed_by text NOT NULL
);
