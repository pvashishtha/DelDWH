-- SQL Basics Day 2

-- Write SQL query to find the employee who is not assigned department id
select * from hr.employees where department_id is null;

-- Write query to find the employees who earn less than 5000 or belong to department 30
select * from hr.employees where salary<5000 or department_id=30;

-- Write query to find the date for next election day in US
select next_day(to_date('31-Oct-26'), 'Tuesday');

-- Write query to find the employees who joined on Sunday
select * from hr.employees where trim(to_char(hire_date, 'Day'))='Sunday';


-- Aggregations

-- Aggregate Functions -> produces single output for multiple input values
    -- count, sum, min, max, avg, variance, stddev

select count(*) from hr.employees;

select count(department_id) from hr.employees;

select count(COMMISSION_PCT) from hr.employees;

select count(distinct department_id) from hr.employees;

select sum(salary), min(salary), max(salary), round(avg(salary), 2) from hr.employees;

select round(variance(salary)), round(stddev(salary)) from hr.employees;

-- department wise sum of salary
    -- GROUP BY

select NVL(department_id, 999), sum(salary) from hr.employees 
    GROUP BY department_id
    ORDER BY department_id;

-- Write query to find department with highest avg salary

select department_id, round(avg(salary)) as avgsal from hr.employees
    group by department_id order by avgsal desc fetch first 1 rows only


-- Find the departments that has at least 5 employees

select department_id, count(*) as cnt from hr.employees
    --where salary>10000
    group by department_id 
    having cnt>=5
    order by cnt desc;


-- Write query to find departments and its max & min salary, for dept which has avg salary more than 10000

select department_id, max(salary) as mxsal, min(salary) as minsal from hr.employees
    group by department_id
    having avg(salary)>10000;


-- Write query to find the duplicate records in emp table

select employee_id from hr.employees
    group by employee_id
    having count(*)>1;


-- JOINS
    -- joning multiple tables together

select * from hr.employees;
select * from hr.departments;
select * from hr.locations;
select * from hr.countries;
select * from hr.regions;

-- JOINS

select * from hr.employees, hr.departments; -- implicit cross join

select * from hr.employees cross join hr.departments;  -- explicit cross join

-- implicit inner join

select * from hr.employees, hr.departments 
    where hr.employees.department_id=hr.departments.department_id;

-- explicit inner join

select * from hr.employees e INNER JOIN hr.departments d
    ON e.department_id=d.department_id;

select * from hr.employees e INNER JOIN hr.departments d
    USING(department_id);

select * from hr.employees e JOIN hr.departments d
    ON e.department_id=d.department_id;


-- Write query to display employee data with department name and city where it is located.

select e.employee_id, e.first_name, e.last_name, d.department_name, l.city
from hr.employees e JOIN hr.departments d 
ON e.department_id=d.department_id JOIN hr.locations l
ON d.location_id=l.location_id;

--=> for n tables, write n-1 joins

-- OUTER JOIN
    -- right, left, full

-- RIGHT OUTER JOIN -> all records from right table are considered, only matched records from left table

select * from hr.employees e RIGHT OUTER JOIN hr.departments d
    ON e.department_id=d.department_id;


select * from hr.employees e RIGHT JOIN hr.departments d
    ON e.department_id=d.department_id;

-- implicit ROJ

select * from hr.employees e, hr.departments d
    where e.department_id(+) = d.department_id;

-- LEFT OUTER JOIN
    -- all records from left table and only matched records form right table

select * from hr.employees e LEFT OUTER JOIN hr.departments d
    ON e.department_id=d.department_id;


select * from hr.employees e LEFT JOIN hr.departments d
    ON e.department_id=d.department_id;

-- implicit LOJ

select * from hr.employees e, hr.departments d
    where e.department_id = d.department_id(+);

-- FULL OUTER JOIN
    -- all records from left & right table 

select * from hr.employees e FULL OUTER JOIN hr.departments d
    ON e.department_id=d.department_id;


select * from hr.employees e FULL JOIN hr.departments d
    ON e.department_id=d.department_id;


-- Find the departments which are not mapped to any employee in employee table, using JOIN operation

select d.department_id, d.department_name from hr.employees e RIGHT JOIN hr.departments d
ON e.department_id=d.department_id
where employee_id is null;


select e.employee_id, e.first_name, e.last_name 
from hr.employees e LEFT JOIN hr.departments d
ON e.department_id=d.department_id
where e.department_id is null;


-- Self JOIN

select e.employee_id, e.first_name, e.last_name, NVL(m.first_name, 'No Manager') as manager
    from hr.employees e LEFT JOIN hr.employees m
    ON e.manager_id=m.employee_id order by e.employee_id;

-- Find the number of employees managed by Steven King

select count(*) as manager
    from hr.employees e JOIN hr.employees m
    ON e.manager_id=m.employee_id
    where m.first_name='Steven' and m.last_name='King';

-- NON EQUI JOINS

create table salgrade(grade char(1) primary key, minsal number, maxsal number);

insert into salgrade values('A', 2000, 5000);
insert into salgrade values('B', 5001, 10000);
insert into salgrade values('C', 10001, 15000);
insert into salgrade values('D', 15001, 20000);
insert into salgrade values('E', 20001, 25000);

select e.employee_id, e.first_name, e.salary, g.grade
from hr.employees e JOIN salgrade g
ON e.salary between g.minsal and g.maxsal
order by e.salary desc;


-- Write a query that counts the region wise employees, sorted by count in descending order.

select r.region_name, count(*) as regional_count from hr.employees e 
join hr.departments d on e.department_id=d.department_id
join hr.locations l on d.location_id=l.location_id 
join hr.countries c on l.country_id=c.country_id
join hr.regions r on c.region_id=r.region_id
group by r.region_name order by regional_count desc;


-- SUBQUERIES

    -- SQ are required to find the unknown items for main query to resolute final result

    -- single valued, list valued, table valued, co-related SQ, inline SQ

-- Write a query to find employees who earn less than Kimberely Grant

select * from hr.employees where salary<(
    select salary from hr.employees where first_name||last_name='KimberelyGrant');

-- Write a query to find number of employees who work in same department with 'Lex'
select count(*)-1 from hr.employees where department_id=(
    select department_id from hr.employees where first_name='Lex'
);

-- Write a query to find average salary of employees who has same job_id like 'Alexander Khoo'
select avg(salary) from hr.employees where job_id=(
    select job_id from hr.employees where first_name||last_name='AlexanderKhoo');

-- Write query to find all employees who earn more than average salary

select * from hr.employees where salary>(select avg(salary) from hr.employees);

-- Write a query to find all employees who are also managers

select first_name from hr.employees where employee_id IN(
    select distinct manager_id from hr.employees where manager_id is not null);

-- ANY-> return true if value matches atleast one from list , ALL-> retuen truw if value matches with all in list

-- Write query to find all employees who earn more than any manager

select * from hr.employees where salary>ANY(
    select distinct salary from hr.employees where employee_id IN(
        select distinct manager_id from hr.employees where manager_id is not null)
) AND employee_id not IN(
    select distinct manager_id from hr.employees where manager_id is not null
);


-- Write a query to find employees who earn maximum salary in company
select first_name, last_name from hr.employees where salary=(
    select max(salary) from hr.employees);


-- Write a query to find employees who earn second highest salary

select first_name, last_name from hr.employees where salary=(
    select max(salary) from hr.employees where salary<(select max(salary) from hr.employees));

-- correlated SQ
select e.first_name, e.last_name from hr.employees e where 1=(
    select count(distinct salary) from hr.employees where e.salary<salary);

-- Write a query to find employees who earn maximum salary in their respective department
select e.first_name, e.last_name, e.department_id from hr.employees e 
    where salary=(select max(salary) from hr.employees where department_id=e.department_id);

-- Write a query to display employee name and salary along with highest salary with each record
    -- inline SQ

select first_name, last_name, salary, (select max(salary) from hr.employees) from hr.employees;

-- EXISTS operator
    -- return true if there is atleast one record returned by SQ

-- write query to find all employees of department 30 if only there is no null value for their job_id

select first_name, last_name from hr.employees where department_id=30 and
    not exists(select * from hr.employees where department_id=30 and job_id is null);

-- Write a query to print names of all employees with job_id as 'SA_MAN' if only one of them is manager

select first_name, last_name from hr.employees where job_id='SA_MAN' and
    exists(select employee_id from hr.employees where job_id='SA_MAN' and employee_id IN(
        select distinct manager_id from hr.employees where manager_id is not null
    ));


-- Write a query to find the department_id and department name for dept that has highest average salary in company

select e.department_id, d.department_name from hr.employees e JOIN hr.departments d
on e.department_id=d.department_id 
group by e.department_id, d.department_name
having avg(salary)=(select max(avg(salary)) from hr.employees group by department_id);


-- WITH Operator

select * from hr.employees where salary>(select avg(salary) from hr.employees);

-- 
WITH CTE(avgsal) as (select avg(salary) from hr.employees)
select employee_id, first_name, last_name from hr.employees, CTE
    where salary>CTE.avgsal;

-- Write a query using WITH operator to get all employees who are also managers

WITH CTE(mgr) as (select distinct manager_id from hr.employees where manager_id is not null)
select * from hr.employees, CTE
    where employee_id IN CTE.mgr;


-- INDEXES
    -- To improve select query performance
    -- clustered (unique) & non-clustered (non-unique)
    -- PK is automatically clustered indexed

create index grade_index on salgrade(minsal);

drop index grade_index;


-- SEQEUNCES
    -- allow to generate numeric values 
create sequence seq1
    start with 10
    increment by 1
    minvalue 5
    maxvalue 15
    nocache
    cycle


select seq1.nextval, seq1.currval, seq1.currval;



-- SET OPERATORS
    -- UNION, UNION ALL, INTERSECT, MINUS

-- UNION
select employee_id, first_name, last_name, salary, department_id from hr.employees where department_id=30
UNION
select employee_id, first_name, last_name, salary, department_id from hr.employees 
    where salary=11000

-- UNION ALL
select employee_id, first_name, last_name, salary, department_id from hr.employees where department_id=30
UNION ALL
select employee_id, first_name, last_name, salary, department_id from hr.employees 
    where salary=11000

-- INTERSECT
select employee_id, first_name, last_name, salary, department_id from hr.employees where department_id=30
INTERSECT
select employee_id, first_name, last_name, salary, department_id from hr.employees 
    where salary=11000

-- MINUS
select employee_id, first_name, last_name, salary, department_id from hr.employees where department_id=30
MINUS
select employee_id, first_name, last_name, salary, department_id from hr.employees 
    where salary=11000


-- 
select employee_id, first_name from hr.employees where department_id=20
UNION
select employee_id, first_name from hr.employees where department_id=40


select employee_id, first_name from hr.employees where department_id=20
UNION
select department_id, department_name from hr.departments where department_id=40


-- Optmizer Hint
    --FIRST_ROWS(n)

select /*+FIRST_ROWS(10) */ employee_id, first_name from hr.employees where department_id=50;

-- EXPLAIN PLAN

EXPLAIN PLAN FOR
select employee_id, first_name, salary 
from hr.employees where department_id IN (20,30,40,50,80) order by salary desc;
select * from table(DBMS_XPLAN.DISPLAY);


-- SYNONYM
    -- DB objects that is alias name for any other object like table/view/func

select * from hr.employees;

create synonym emp for hr.employees;

select * from emp;

drop synonym emp;




-- Write SQL query to display employee details along with salary and salary hike eligibility if salary is less
    -- than 10000. In such a case display eligible or not eligible status and for eligible employees
    -- display new salary with 10% hike, for non eligible, display same salary.

select employee_id, first_name, last_name, salary,
CASE when salary<=10000 then 'Eligible' else 'Not Eligible' end as eligibility,
CASE when salary<10000 then salary*1.1 else salary end as new_salary
from hr.employees;