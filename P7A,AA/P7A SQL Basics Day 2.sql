-- SQL Basics Day 1

    -- SQL -> structured query language
        -- DML, DDL, DCL, TCL, DQL
    -- DDL -> Data Definition Language  [CREATE, ALTER, DROP, TRUNCATE]

create table student_info(student_id int, fullname varchar2(30), joining_date date, 
    course varchar2(20), fees number(8,2));
-- Data Types: INTEGER, NUMBER, CHAR, VARCHAR2, DATE, DATETIME, TIMESTAMP, CLOB, BLOB

desc student_info;

-- add column
ALTER table student_info ADD student_mobile number;
-- modify column
ALTER table student_info MODIFY student_mobile varchar2(10);
-- rename column
ALTER table student_info RENAME COLUMN student_mobile TO mobile_number;
-- drop column
ALTER table student_info DROP COLUMN mobile_number;

    -- DML -> Data Manipulation Language [INSERT, UPDATE, DELETE]
INSERT into student_info values(101, 'Prateek', '26-Oct-26', 'SQL', 7500);

INSERT into student_info values(102, 'Aditi', '21-Sep-26', 'Python', 9000);

-- UPDATE
UPDATE student_info SET fees=11000 where student_id=102;

UPDATE student_info SET course='SQL Basics', fees=4500 where student_id=101;

UPDATE student_info set course='SQL Fdn';

-- DELETE
DELETE from student_info where student_id=102;

DELETE from student_info;

-- TRUNCATE
TRUNCATE table STUDENT_INFO;

-- DELETE ALL vs TRUNCATE
    -- DELETE can be ROLLBACKED, but not TRUNCATE
    -- DELETE - Temporary, Truncate - Permanent
    -- DELETE - does not free space, TRUNCATE - free space immediately
    -- DELETE - fire triggers, TRUNCATE - prevent triggers

-- DROP
DROP table student_info;


select * from STUDENT_INFO;

    -- DCL -> Data Control Language [GRANT, REVOKE]
GRANT create table to user;

GRANT select, insert, update ON student_info TO user;

REVOKE create table from user;

REVOKE update ON student_info FROM user;


    -- TCL -> Transaction Control Language [COMMIT, ROLLBACK, SAVEPOINT]

create table student_info(stdid int, fullname varchar2(50));
insert into student_info values(101, 'Prateek');
insert into student_info values(102, 'Saksham');
insert into student_info values(103, 'Aditi');
COMMIT;
update student_info set stdid=909 where stdid=103;
ROLLBACK;
delete from student_info where stdid=102;
COMMIT;

select * from student_info;


-- Solve:
-- create table sample with sample id and sample description
create table sample(sampleid int, sampledesc varchar2(20));
-- add column sample_date and sample_cost
alter table sample add sample_date date; 
alter table sample add sample_cost number;
-- rename column sample_cost to sample_price
alter table sample rename column sample_cost to sample_price;
-- change datatype of sample_date to varchar
alter table sample modify sample_date varchar2(20);
-- drop column sample_date
alter table sample drop column sample_date;


    -- DQL -> Data Query Language [SELECT, FETCH]

select * from hr.employees;

-- projection
select employee_id, first_name, salary from hr.employees;

-- filter [WHERE clause]
select employee_id, first_name, salary from hr.employees where department_id=20;

-- IN operator
select employee_id, first_name, salary, department_id 
    from hr.employees where department_id IN(10,20,30,40);

-- between operator -> BETWEEN x AND y
select employee_id, first_name, salary from hr.employees where salary between 2000 and 5000;

-- like operator -> filter character data based on matching pattern
    -- % wildcard matching any number of chars, _ wildcard matches exactly 1 character
select first_name, last_name from hr.employees where first_name like 'Ste_en';

select first_name, last_name from hr.employees where first_name like 'Ste%';

-- Operations - arithmetic, logical, comparison
select first_name, salary, salary*12 as annual_salary from hr.employees;


select first_name, salary, salary*12 as annual_salary from hr.employees where salary>10000;


-- Constraints
    -- NOT NULL, CHECK, UNIQUE, PK, FK, DEFAULT

create table sample(
    sample_id integer primary key,
    sample_desc varchar2(100) default 'Unknown',
    sample_price number check(sample_price>0),
    sample_mfg_date date not null,
    sample_hash_code varchar2(100) unique
);


create table sample(
    sample_id integer,
    sample_desc varchar2(100) default 'Unknown',
    sample_price number,
    sample_mfg_date date not null,
    sample_hash_code varchar2(100),
    CONSTRAINT sample_id_pk primary key (sample_id),
    CONSTRAINT sample_price_check  check(sample_price>0),
    CONSTRAINT sample_hash_code_unq unique(sample_hash_code)
);

insert into sample values(10, 'Sample10', 2300, '26-Oct-26', 'Hash10');

insert into sample(sample_id, sample_price, sample_mfg_date, sample_hash_code) 
    values(20, 2300, '26-Oct-26', 'Hash20');

select * from sample;


insert into sample values(30, 'Sample30', 2100, '26-Oct-26', 'Hash30');


-- Foreign Key

create table product(product_id int primary key, product_name varchar2(20), price number);
insert into product values(10, 'Milk', 56);
insert into product values(20, 'Bread', 70);
insert into product values(30, 'Juice', 90);
insert into product values(40, 'Butter', 120);
insert into product values(50, 'Jam', 215);

create table sales(
    sales_id int primary key,
    sales_date date,
    sales_amount number,
    prod_id int,
    CONSTRAINT pro_id_fk FOREIGN KEY (prod_id) references product(product_id)
    ON DELETE CASCADE
);

insert into sales values(901, sysdate, 25000, 10);
insert into sales values(902, sysdate, 21000, 20);
insert into sales values(903, sysdate, 29000, 30);

delete from product where product_id=10;

select * from sales;

drop table sales;


-- SORTING DATA

    -- order by clause

select first_name, salary from hr.employees order by salary; -- default ascending order ASC

select first_name, salary from hr.employees order by salary DESC;


select employee_id, first_name, salary, department_id 
    from hr.employees 
    order by department_id, salary;

select employee_id, first_name, salary, department_id 
    from hr.employees 
    order by 4, 3;


-- Write SQL query to find all employees who belong to department 80 and earn more than 10000 
select employee_id, first_name, salary from hr.employees where department_id=80 and salary>10000;

-- Write SQL query to find all employees whose last name ends with 'a' or 'n'
select first_name, last_name from hr.employees where last_name like '%n' or last_name like '%a';

-- Write SQL query to display top 5 highest salary earning employees of department 50

select * from hr.employees where department_id=50 order by salary desc fetch first 5 rows only;

-- Write SQL query to diplay employees records from 6th record to 10th record

select * from hr.employees offset 5 rows fetch next 5 rows only;

----

-- Single Row Functions -> apply to each row in table attribute and produces a result for each row data

-- Character Functrion, General, Date, Numeric, Conversion

-- CHARACTER FUNCTIONS
    -- upper, lower, initcap, instr, lapd, rpad, length, concat, trim, ltrim, rtrim, substr

-- upper, lower, initcap

select upper('hello');

select lower('HELLO');

select initcap('python programming');

select initcap('pYTHON programming');


select first_name, upper(first_name) as upper_name from hr.employees;


select concat('hello ', 'world ', 'from SQL');

select concat(concat('hello ', 'world '), 'from SQL');

select 'hello ' || 'world ' || 'from SQL';

-- lpad, rpad

select lpad('HELLO', 10, '*');

select rpad('HELLO', 10, '*');

trim, ltrim, rtrim, length

select length('    hello    '), trim('    hello    '), length(trim('    hello    '));

select length('    hello    '), rtrim('    hello    '), length(rtrim('    hello    '));

select length('    hello    '), ltrim('    hello    '), length(ltrim('    hello    '));


select ltrim('@#$$@#$@$HELLO$#@$#@$#@$#%', '@#$');

select rtrim('@#$$@#$@$HELLO$#@$#@$#@$#', '@#$');

-- substr(str, start, num_of_chars)
select substr('HELLO WORLD', 7, 3);

select substr('HELLO WORLD', -3, 3);

-- instr(str, substr, start)

select instr('ABRAKADABRA', 'A', 5);

-- replace

select replace('ABRAKADABRA', 'A', '@');

-- Numeric Functions
    -- abs, ceil, floor, round, log, sin, cos, tan, power, sqrt

select sin(30), cos(30), tan(30);

select power(3, 5);

select abs(-867);

select sqrt(289);

select log(2, 8);

select round(3.145678976577, 3);

select trunc(3.145678976577, 3);

select floor(3.89), ceil(3.02);

-- GENERAL FUNCTIONS
    -- NVL, NVL2, COALEASCE, NULLIF, DECODE, CASE, REGEXP_LIKE, REGEXP_REPLACE

-- NVL, NVL2

select first_name, commission_pct, NVL(commission_pct, 0) from hr.employees;

select first_name, commission_pct, NVL2(commission_pct, 1, 0) from hr.employees;

-- NULLIF(v1, v2)

select nullif('hi', 'HI');

select nullif('hi', 'hi');


-- coalesce(list_of_null_nonnull) -> return first non null value

select first_name, commission_pct, salary, coalesce(commission_pct, salary) from hr.employees;

-- DECODE
select first_name, job_id, DECODE(job_id, 'SA_REP', 'Sales', 'Others') from hr.employees;

-- CASE

SELECT first_name, salary, job_id,
CASE job_id
    when 'SA_REP' then 'Sales Repesentative'
    when 'SA_MAN' then 'Sales Manager'
    when 'AD_PRES' then 'President'
    when 'AD_VP' then 'Vice President'
    when 'IT_PROG' then 'Programmer'
    else 'Others' 
END AS Job_Roles
FROM hr.employees;

select first_name, salary,
CASE when salary>10000 then 'High Salary' else 'Low Salary' END as salary_type
from hr.employees;

-- REGEXP_LIKE and REGEXP_REPLACE

select first_name, last_name from hr.employees where regexp_like(last_name, '^[A-Z][a-z]+l$');

select first_name, regexp_replace(first_name, '^[A-Z][a-z]{4}$', '#') from hr.employees;

-- conversion functions

    -- to_number(), to_date(), to_char()

select to_number('3.145');

select to_number('6589');

select to_number(replace('34%', '%', ''));

select to_number(substr('34%', 1, 2));

-- to_date()

select to_date('26-Oct-26');

select to_date('2026-10-26', 'YYYY-MM-DD');

select to_date('20262610110501', 'YYYYDDMMHHMISS');

-- to_char()

select 3.1456, to_char(3.145);

select to_char(sysdate);

select hire_date, to_char(hire_date, 'Day Month DD, YYYY') from hr.employees;

select hire_date, to_char(hire_date, 'Day Month DD, Year') from hr.employees;

select first_name, salary, to_char(salary, '$999,999,999.99') from hr.employees;


-- Date Functions
    -- months_between, add_months, last_day, next_day

select months_between(sysdate, '18-Nov-1994');

select add_months(sysdate, 78);

select last_day(sysdate);

select last_day('01-Feb-2034');

select next_day(sysdate, 'Friday');

-- extract
    select extract(day from sysdate);
    select extract(month from sysdate);
    select extract(year from sysdate);

    select extract(hour from systimestamp);
    select extract(minute from systimestamp);
    select extract(second from systimestamp);

-- Write SQL query to find number of blank spaces in given string 'server test failed badly'
select 'server test failed badly',
    length('server test failed badly')-length(replace('server test failed badly', ' ', '')) as spaces;

-- Write SQL query to find all employees who joined in 2015
select employee_id, first_name, hire_date from hr.employees where extract(year from hire_date)=2015;