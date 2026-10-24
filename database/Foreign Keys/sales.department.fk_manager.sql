ALTER TABLE sales.department ADD CONSTRAINT fk_department_manager FOREIGN KEY (manager_id) REFERENCES sales.employee (employee_id);
