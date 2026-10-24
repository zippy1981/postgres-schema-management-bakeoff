#!/usr/bin/env bash
# Control: applies database/ with psql in a hand-written dependency order. Each file is
# listed by hand, so this is the best a sequential loader can do without a tool.
set -euo pipefail
cd "$(dirname "$0")/../../.."

ordered=(
  Schemas/audit.sql
  Schemas/inventory.sql
  Schemas/sales.sql
  Tables/audit.change_log.sql
  Tables/inventory.category.sql
  Tables/inventory.product.sql
  Tables/sales.customer.sql
  Tables/sales.department.sql
  Tables/sales.employee.sql
  Tables/sales.order_header.sql
  Tables/sales.order_detail.sql
  "Foreign Keys/sales.department.fk_manager.sql"
  "Foreign Keys/sales.employee.fk_department.sql"
  Views/inventory.v_category_tree.sql
  Views/sales.v_order_detail.sql
  Views/sales.v_customer_totals.sql
  Procedures/sales.set_order_status.sql
)

for file in "${ordered[@]}"; do
  echo "ordered-psql: $file"
  psql "$DATABASE_URL" -v ON_ERROR_STOP=1 -q -f "database/$file"
done
