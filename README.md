# 🧩 SQL Practice — Common Table Expressions (CTEs)

This repository contains a collection of **SQL problems** that demonstrate the **power, readability, and versatility of Common Table Expressions (CTEs)** in solving analytical and business-related challenges.

---

## 📘 Overview

Each example in this repository includes:
- 📝 **A short problem description**
- 💡 **The intuition or logic behind the approach**
- 💻 **A complete SQL solution**

These exercises are designed to help strengthen your understanding of **CTEs**, **aggregate functions**, **window functions**, and **query optimization techniques**.

---

## 📚 Table of Contents

1. [Employees Earning More Than the Company Average](#-1-employees-earning-more-than-the-company-average)
2. [Employees Earning More Than Their Department’s Average](#-2-employees-earning-more-than-their-departments-average)
3. [Customers Spending More Than the Average Total Spending](#-3-customers-spending-more-than-the-average-total-spending)
4. [Top 3 Highest-Paid Employees Per Department](#-4-top-3-highest-paid-employees-per-department)
5. [Customers with 3 or More Orders](#-5-customers-with-3-or-more-orders)
6. [Concepts Practiced](#️-concepts-practiced)
7. [Summary](#-summary)
8. [Author](#-author)

---

## 🧠 1. Employees Earning More Than the Company Average

### 📝 Problem
Find all employees earning more than the company’s average salary.

### 💡 Intuition
1. Use a CTE to calculate the overall average salary.  
2. Compare each employee’s salary to that average.

### 💻 SQL Solution
```sql
WITH avg_sal AS (
    SELECT AVG(salary) AS avgsal FROM emp
)
SELECT * 
FROM emp, avg_sal 
WHERE emp.salary > avg_sal.avgsal;
```
## 🧭 2. Employees Earning More Than Their Department’s Average

### 📝 Problem
List employees whose salary is higher than the average salary of their department.

### 💡 Intuition
1.Calculate the average salary for each department using GROUP BY inside a CTE.
2.Join the CTE with the employee table to find those earning above their department’s average.

###  💻 SQL Solution
```sql
WITH dept_avg AS (
    SELECT department_id, AVG(salary) AS avg_dept_sal 
    FROM emp 
    GROUP BY department_id
)
SELECT CONCAT(e.first_name, ' ', e.last_name) AS full_name,
       e.department_id, e.salary, d.avg_dept_sal 
FROM emp e 
JOIN dept_avg d
ON e.department_id = d.department_id
WHERE e.salary > d.avg_dept_sal
ORDER BY e.department_id, e.salary DESC;
```
## 💰 3. Customers Spending More Than the Average Total Spending
### 📝 Problem
Find customers who have spent more than the average spending across all customers.

### 💡 Intuition
1.Compute each customer’s total spending.
2.Calculate the overall average spending.
3.Compare each customer’s total to the average.

### 💻 SQL Solution
```sql
WITH customer_totals AS (
    SELECT customer_id, SUM(amount) AS total_spent
    FROM orders
    GROUP BY customer_id
),
overall_avg AS (
    SELECT AVG(total_spent) AS avg_spent
    FROM customer_totals
)
SELECT c.customer_id, c.total_spent
FROM customer_totals c, overall_avg o
WHERE c.total_spent > o.avg_spent
ORDER BY c.total_spent DESC;
```
## 🏆 4. Top 3 Highest-Paid Employees Per Department

###📝 Problem
Retrieve the top 3 highest-paid employees within each department.

### 💡 Intuition
1.Assign row numbers to employees within each department using the ROW_NUMBER() window function.
2.Select only those rows where the rank ≤ 3.

### 💻 SQL Solution
```sql
WITH ranked_employees AS (
    SELECT emp_id, first_name, department_id, salary,
           ROW_NUMBER() OVER(PARTITION BY department_id ORDER BY salary DESC) AS rnk
    FROM emp
)
SELECT * 
FROM ranked_employees 
WHERE rnk <= 3;
```
## 📦 5. Customers with 3 or More Orders
### 📝 Problem
Find all customers who have placed at least 3 orders.

## 💡 Intuition
1.Count the number of orders per customer using GROUP BY.
2.Use a CTE to filter out customers with 3 or more orders.

### 💻 SQL Solution
```sql
WITH customer_orders AS (
    SELECT customer_id, COUNT(order_id) AS total_orders 
    FROM orders 
    GROUP BY customer_id
)
SELECT * 
FROM customer_orders 
WHERE total_orders >= 3;
```
### ⚙️ Concepts Practiced

🧩 Common Table Expressions (CTEs)
🧮 Aggregate Functions (AVG, SUM, COUNT)
📊 Window Functions (ROW_NUMBER())
🔗 Data Filtering & Joins
🧠 Analytical Query Patterns

### 🧾 Summary

This SQL set showcases how CTEs can:

✅ Break down complex logic into simple, readable blocks
✅ Simplify subqueries and multi-step joins
✅ Enhance query clarity and maintainability

Each query builds upon real-world business logic — from analyzing employee salaries to understanding customer behavior.

👨‍💻 Author
Vivek Pradhan
SQL Practice | Analytical Query Building | Real-world Business Logic

⭐ If you found this helpful, consider giving the repository a star! ⭐
