SELECT * FROM employees;
SELECT * FROM departments_info;
SELECT * FROM Locations;
SELECT DISTINCT salary
FROM employees;
alter table employees
add column Age int;
SELECT 
    age AS Employee_Age,
    salary AS Employee_Salary
FROM employees;
SELECT *
FROM employees
WHERE salary > 50000
  AND date_of_joining < '2016-01-01';
 SELECT 
    employee_id,
    employee_name,
    COALESCE(NULLIF(TRIM(designation), ''), 'Data Scientist') AS designation
FROM employees
WHERE designation IS NULL
   OR TRIM(designation) = ''; 
   SELECT *
FROM employees
ORDER BY department_id ASC, salary DESC;
SELECT *
FROM employees
WHERE date_of_joining >= '2018-01-01'
  AND date_of_joining < '2019-01-01'
ORDER BY date_of_joining ASC
LIMIT 5;
SELECT SUM(e.salary) AS total_finance_salary
FROM employees e
JOIN departments_info d ON e.department_id = d.department_id
WHERE d.department_name = 'Finance';
SELECT MIN(age) AS minimum_age
FROM employees;
SELECT 
    l.location,
    MAX(e.salary) AS max_salary
FROM employees e
JOIN locations l ON e.location_id = l.location_id
GROUP BY l.location_id, l.location;
SELECT 
    designation,
    AVG(salary) AS avg_salary
FROM Employees
WHERE designation LIKE '%Analyst%'
GROUP BY designation;
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS employee_count
FROM departments_info d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name
HAVING COUNT(e.employee_id) < 3;
SELECT 
    l.location,
    AVG(e.age) AS avg_female_age
FROM employees e
JOIN locations l ON e.location_id = l.location_id
WHERE e.gender = 'Female'
GROUP BY l.location_id, l.location
HAVING AVG(e.age) < 30;
SELECT 
    employee_name AS employee_name,
    e.designation,
    d.department_name
FROM employees e
INNER JOIN departments_info d ON e.department_id = d.department_id;
SELECT 
    d.department_name,
    COUNT(e.employee_id) AS total_employees
FROM departments_info d
LEFT JOIN employees e ON d.department_id = e.department_id
GROUP BY d.department_id, d.department_name;
SELECT 
    l.location,
    employee_name AS employee_name
FROM employees e
RIGHT JOIN locations l ON e.location_id = l.location_id;