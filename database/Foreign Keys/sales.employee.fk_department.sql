ALTER TABLE sales.employee ADD CONSTRAINT fk_employee_department FOREIGN KEY (department_id) REFERENCES sales.department (department_id);
