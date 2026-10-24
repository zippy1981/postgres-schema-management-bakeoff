SELECT n.nspname, n.nspname, 'schema'
FROM pg_namespace AS n
WHERE n.nspname NOT LIKE 'pg\_%' AND n.nspname NOT IN ('information_schema', 'public')
UNION ALL
SELECT n.nspname, c.relname,
    CASE c.relkind
        WHEN 'r' THEN 'table'
        WHEN 'v' THEN 'view'
        WHEN 'm' THEN 'materialized view'
        WHEN 'S' THEN 'sequence'
        WHEN 'i' THEN 'index'
        WHEN 'f' THEN 'foreign table'
    END
FROM pg_class AS c
INNER JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE c.relkind IN ('r', 'v', 'm', 'S', 'i', 'f')
    AND n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
UNION ALL
SELECT n.nspname, p.proname,
    CASE p.prokind WHEN 'p' THEN 'procedure' WHEN 'f' THEN 'function' ELSE 'other' END
FROM pg_proc AS p
INNER JOIN pg_namespace AS n ON n.oid = p.pronamespace
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema')
UNION ALL
SELECT n.nspname, con.conname, 'constraint ' || con.contype::text
FROM pg_constraint AS con
INNER JOIN pg_namespace AS n ON n.oid = con.connamespace
WHERE n.nspname NOT IN ('pg_catalog', 'information_schema', 'pg_toast')
    -- NOT NULL is a pg_constraint row (contype 'n') from PostgreSQL 18 on, and not before.
    -- Leaving it in makes the object list depend on the server version.
    AND con.contype <> 'n'
UNION ALL
SELECT n.nspname, t.tgname, 'trigger'
FROM pg_trigger AS t
INNER JOIN pg_class AS c ON c.oid = t.tgrelid
INNER JOIN pg_namespace AS n ON n.oid = c.relnamespace
WHERE NOT t.tgisinternal AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY 1, 3, 2;
