VRSTARTUPCOMPNAY.sql

--Examine the data from the employees table.

SELECT *
FROM employees;

--Examine data from projects table

SELECT *
FROM projects;

--JOin two tables

SELECT *
FROM projects
INNER JOIN employees
  ON projects.project_id = employees.current_project;

  --Names of employees that have not chosen a project_id

  SELECT first_name, last_name
FROM employees
WHERE employees.current_project IS NULL;

--Names of projects that were not chosen by any employees

SELECT project_name
FROM projects
WHERE project_id NOT IN (
  SELECT current_project
  FROM employees
  WHERE current_project IS NOT NULL
);

--Name of project chosen the most by the employees

SELECT project_name
FROM projects
INNER JOIN employees
  ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL
GROUP BY project_name
ORDER BY COUNT(employee_id) DESC
LIMIT 1; 

--Which projects were chosen by multiple employees?

SELECT project_name
FROM projects
INNER JOIN employees
  ON projects.project_id = employees.current_project
WHERE current_project IS NOT NULL
GROUP BY current_project
HAVING COUNT (current_project) > 1;

--Which personality is the most common accross empolyees

SELECT personality
FROM employees
GROUP BY personality
ORDER BY COUNT (personality) DESC
LIMIT 1;

--Names of projects chosen by most common personality type?

SELECT project_name 
FROM projects
INNER JOIN employees 
  ON projects.project_id = employees.current_project
WHERE personality = (
   SELECT personality
   FROM employees
   GROUP BY personality
   ORDER BY COUNT(personality) DESC
   LIMIT 1);

--Find the personality type most represented by employees with a selected project.
--What are names of those employees, the personality type, and the names of the project they’ve chosen?

SELECT last_name, first_name, personality, project_name
FROM employees
INNER JOIN projects 
  ON employees.current_project = projects.project_id
WHERE personality = (
   SELECT personality 
   FROM employees
   WHERE current_project IS NOT NULL
   GROUP BY personality
   ORDER BY COUNT(personality) DESC
   LIMIT 1);

--For each employee, provide their name, personality, the names of any projects they’ve chosen, and the number of incompatible co-workers.

SELECT last_name, first_name, personality, project_name,
CASE 
   WHEN personality = 'INFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('ISFP', 'ESFP', 'ISTP', 'ESTP', 'ISFJ', 'ESFJ', 'ISTJ', 'ESTJ'))
   WHEN personality = 'ISFP' 
   THEN (SELECT COUNT(*)
      FROM employees 
      WHERE personality IN ('INFP', 'ENTP', 'INFJ'))
   -- ... etc.
   ELSE 0
END AS 'IMCOMPATS'
FROM employees
LEFT JOIN projects on employees.current_project = projects.project_id;