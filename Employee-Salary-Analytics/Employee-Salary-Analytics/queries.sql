-- Employee Salary Analytics

-- 1. Top 2 highest earners in each department:
SELECT name, salary, dept_name
FROM (
    SELECT e.name, e.salary, d.dept_name,
           DENSE_RANK() OVER (PARTITION BY d.dept_id ORDER BY e.salary DESC) AS salary_rank
    FROM employees e
    JOIN departments d
        ON e.dept_id = d.dept_id
)
WHERE salary_rank <= 2;


-- 2. Employees earning above department average salary:
SELECT name, salary, dept_name, dept_avg_salary
FROM (
    SELECT e.name, e.salary, d.dept_name, 
          AVG(e.salary) OVER (PARTITION BY d.dept_id) AS dept_avg_salary
    FROM employees e
    JOIN departments d
        ON e.dept_id = d.dept_id
)
WHERE salary > dept_avg_salary;


-- 3. Employee salary, department average, and rank:
SELECT e.name, e.salary, d.dept_name, 
       AVG(e.salary) OVER (PARTITION BY d.dept_id) AS dept_avg_salary,
       DENSE_RANK() OVER (PARTITION BY d.dept_id ORDER BY e.salary DESC) AS dept_salary_rank
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id;


-- 4. Departments with high total salary budget
SELECT d.dept_name, SUM(e.salary) AS total_salary, COUNT(e.emp_id) AS employee_count
FROM employees e
JOIN departments d
    ON e.dept_id = d.dept_id
GROUP BY d.dept_name
HAVING SUM(e.salary) > 100000 AND COUNT(e.emp_id) > 1;


-- 5. Managers ranked by total team salary
SELECT m.manager_name, SUM(e.salary) AS team_total_salary, 
      RANK() OVER (ORDER BY SUM(e.salary) DESC) AS team_rank
FROM employees e
JOIN manager m
    ON e.manager_id = m.manager_id
GROUP BY m.manager_name;
