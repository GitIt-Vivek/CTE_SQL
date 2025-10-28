
-- CTEs(Common Table Expressions) :
--  	Think of it as a temporary result table that exists only for
--  	the duration of the query.
 /*
	 Syntax : 
			  with cte_name as (
				select * from table_name
				where condition
			  ) select * from cte_name;
*/
create database ctebasics;
use ctebasics;

create table emp (
	emp_id int primary key,
    first_name varchar(20),
    last_name varchar(20),
    department_id int,
    salary decimal(10,2),
    hire_date DATE
);

insert into emp(emp_id,first_name,last_name,department_id,salary,hire_date) 
values(1, 'Alice', 'Johnson', 101, 75000, '2020-02-10'),
(2, 'Bob', 'Smith', 101, 50000, '2021-06-15'),
(3, 'Carol', 'White', 102, 90000, '2019-03-12'),
(4, 'David', 'Brown', 102, 85000, '2021-11-09'),
(5, 'Eve', 'Davis', 103, 60000, '2022-05-20'),
(6, 'Frank', 'Miller', 101, 95000, '2018-07-22'),
(7, 'Grace', 'Wilson', 103, 55000, '2023-03-02'),
(8, 'Henry', 'Moore', 104, 70000, '2020-12-10');

CREATE TABLE departments (
  department_id INT PRIMARY KEY,
  department_name VARCHAR(50)
);

INSERT INTO departments (department_id, department_name) VALUES
(101, 'Engineering'),
(102, 'Finance'),
(103, 'Sales'),
(104,'HR');

CREATE TABLE orders (
  order_id INT PRIMARY KEY,
  customer_id INT,
  amount DECIMAL(10,2),
  order_date DATE
);

INSERT INTO orders (order_id, customer_id, amount, order_date) VALUES
(1, 201, 250.00, '2024-05-01'),
(2, 202, 400.00, '2024-05-02'),
(3, 201, 300.00, '2024-06-10'),
(4, 203, 150.00, '2024-06-15'),
(5, 204, 600.00, '2024-07-03'),
(6, 201, 200.00, '2024-07-20'),
(7, 202, 800.00, '2024-07-25'),
(8, 205, 500.00, '2024-08-01'),
(9, 203, 200.00, '2024-08-05'),
(10, 204, 700.00, '2024-08-12');

select * from emp;
select * from departments;
select * from orders;

-- Task 1 : Find all the employees earning more than the company's average salary.

-- intuition :  first we can find the average salary of each employee by agg. function in the cte.
--  			then, from the cte we can find the employees more than the avg salary in the main query.

-- avg :
Select avg(salary) as avg_sal 
from emp; -- Return the average salary of the table 

-- using as cte 

with avg_sal as (
	select avg(salary) as avgsal from emp
) 
select * from emp, avg_sal 
where emp.salary > avg_sal.avgsal;


-- Task 2 : Find the average salary of each department and list all the employees 
-- 			who earn more than their department average.
-- intuition : first we can get the avg salary of eac department using group by in the cte.
-- 				Then, using cte , we can find the eployees earning more than their department average by joining
-- 				the two tables 
-- department average :
select department_id,avg(salary) as avg_dept from emp group by department_id;
-- using dept avg as cte in main query : 

with dept_avg as (
	select department_id,avg(salary) as avg_dept_sal 
    from emp group by department_id
) select concat(e.first_name,' ',e.last_name) as full_name,
e.department_id, e.salary, d.avg_dept_sal 
from emp e 
join dept_avg d
on e.department_id = d.department_id
where e.salary > d.avg_dept_sal
order by e.department_id, e.salary desc;

-- Task 3 : Find customers who spent more than their avg total spendings.

-- 	intuition : we can first find the total amount spent by each customer by using group by
-- 				Then we can find the average spent amount of the total spent by all the customers. 
--  			from both the ctes, we can compare and find the customers who spent more than their average amount.

--  total spent :
with customer_totals as (
	select customer_id, sum(amount) as total_spent
    from orders
    group by customer_id
), overall_avg as (
	select avg(total_spent) as avg_spent
    from customer_totals
) select c.customer_id,c.total_spent
from customer_totals c, overall_avg o
where c.total_spent > o.avg_spent
order by c.total_spent desc;

-- Task 4 : Top 3 paid employees for each department
-- intuition : we can first give row numbers to employees based on their salaries in descending order in cte.
-- 				then we can just select the employees with row_number <= 3 in tthe main query
-- cte :  assinging row number
select department_id,salary,
row_number() over(partition by department_id order by salary desc) as rnk
from emp;

-- Adding it into the main query
with ranked_employees as (
	select emp_id,first_name,department_id,salary,
	row_number() over(partition by department_id order by salary desc) as rnk
	from emp
)
select * from ranked_employees 
where rnk <= 3;

-- Task 5 : Customers with >= 3 orders
-- Intuition : we can count the orders of each customers and group them by customer id
--             in desc order, then use it in main query to filter the required cuxtomers

-- cte : 
select customer_id, count(order_id) as total_orders from orders group by customer_id;
-- Writing it with main query :
with customer_orders as (
	select customer_id, count(order_id) as total_orders 
    from orders group by customer_id
)
select * from customer_orders 
where total_orders >= 3;