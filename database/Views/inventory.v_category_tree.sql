CREATE VIEW inventory.v_category_tree AS
WITH RECURSIVE tree AS (
    SELECT
        category_id,
        parent_id,
        name,
        1 AS tree_depth
    FROM inventory.category
    WHERE parent_id IS NULL

    UNION ALL

    SELECT
        c.category_id,
        c.parent_id,
        c.name,
        t.tree_depth + 1 AS tree_depth
    FROM inventory.category AS c
    INNER JOIN tree AS t ON c.parent_id = t.category_id
)

SELECT
    category_id,
    parent_id,
    name,
    tree_depth
FROM tree;
