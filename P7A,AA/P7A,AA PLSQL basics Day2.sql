-- PLSQL Basics Day 2

-- Write PLSQL code to display all department ID and department names from departments table.
BEGIN
    for emp in (select department_id, department_name from hr.departments) loop
        DBMS_OUTPUT.PUT_LINE('Department ID: '||emp.department_id);
        DBMS_OUTPUT.PUT_LINE('Department Name: '||emp.department_name);
        DBMS_OUTPUT.PUT_LINE('==================');
    end loop;
END;

-- Write PLSQL code to print first and last name of employee with email created using first letter from first name
    -- and last name, concatenated in lower case with domain as '@sendemail.com'

BEGIN
    for emp in (select first_name, last_name from hr.employees) loop
        DBMS_OUTPUT.PUT_LINE('First Name: '||emp.first_name);
        DBMS_OUTPUT.PUT_LINE('Last Name: '||emp.last_name);
        DBMS_OUTPUT.PUT_LINE('Email: '||lower(substr(emp.first_name,1,1)||emp.last_name||'@sendemail.com'));
        DBMS_OUTPUT.PUT_LINE('==================');
    end loop;
END;

-- CURSOR
    -- implicit cursor-> created and maintained by server -> represented by SQL keyword
    -- explicit cursor-> created and maintained/used by programmer -> rep by cursor name

-- creating first explicit cursor 

declare
    CURSOR cur IS select * from hr.employees where department_id=30;
    v_rec hr.employees%rowtype;
begin
    OPEN cur;
    LOOP
        FETCH cur into v_rec;
        EXIT WHEN cur%NOTFOUND;
        dbms_output.put_line(v_rec.employee_id||' '||v_rec.first_name||' '||v_rec.last_name );
    END LOOP;
    CLOSE cur;
end;

-- Write code to print name, salary and cumulative sum of salary againt each record for dept 30 employees
declare
    CURSOR cur IS select * from hr.employees where department_id=30;
    v_rec hr.employees%rowtype;
    v_cumulative_sum_salary number:=0;
begin
    OPEN cur;
    LOOP
        FETCH cur into v_rec;
        EXIT WHEN cur%NOTFOUND;
        v_cumulative_sum_salary:=v_cumulative_sum_salary+v_rec.salary;
        dbms_output.put_line(v_rec.first_name||' '||v_rec.salary||' '||v_cumulative_sum_salary );
    END LOOP;
    CLOSE cur;
end;

-- Cursor with For loop

declare
    CURSOR cur is select * from hr.employees where department_id=90;
begin
    for rec in cur loop
        dbms_output.put_line(rec.employee_id||' '||rec.first_name||' '||rec.salary);
    end loop;
end;

-- Write code with cursor in for loop to display department and count of employees for each dept.

declare
    cursor cur is select d.department_name, count(e.employee_id) as cnt from hr.employees e join hr.departments d
        on e.department_id=d.department_id group by d.department_name;
begin
    for rec in cur LOOP
        dbms_output.put_line(rpad(rec.department_name,20,' ')||' '||rec.cnt);
    end loop;
end;

--  Cursor Attributes
declare
    cursor cur is select * from hr.employees where department_id=50;
    v_rec hr.employees%rowtype;
begin
    open cur;
    loop
        fetch cur into v_rec;
        exit when cur%notfound;
        dbms_output.put_line('DEPT ID: '||v_rec.first_name);
    end loop;
    dbms_output.put_line('Count: '||cur%ROWCOUNT);
    close cur;
end;

-- Parametrised Cursors

declare
    CURSOR cur(dept integer) is select * from hr.employees where department_id=dept;
    rec hr.employees%rowtype;
    v_dept integer default 10;
begin
    v_dept:=&EnterDept;
    OPEN cur(v_dept);
    LOOP
        FETCH cur into rec;
        EXIT WHEN cur%NOTFOUND;
        dbms_output.put_line(rec.first_name);
    END LOOP;
    CLOSE cur;
end;


-- Write a code with parametrised cursor to get employees name who work in certain dept and
    -- earn more than specified salary. [Hint: dept and salary as parameter to cursor]

declare
    CURSOR cur(dept integer, sal number) is select * from hr.employees where department_id=dept and salary>sal;
    v_rec hr.employees%rowtype;
    v_dept integer;
    v_sal number;
begin
    v_dept:=&EnterDept;
    v_sal:=&EnterSalary;
    open cur(v_dept, v_sal);
    loop    
        fetch cur into v_rec;
        exit when cur%notfound;
        dbms_output.put_line(v_rec.first_name);
    end loop;
    close cur;
end;


-- EXCEPTION HANDLING IN PLSQL

declare
    x integer:=10;
    y integer:=0;
begin
    x:=&EnterX;
    select salary into y from hr.employees where employee_id=x;
    x:=x/y;
    dbms_output.put_line('X= '||x);
    exception 
        when VALUE_ERROR then dbms_output.put_line('Either X or Y can not be non-numeric');
        when ZERO_DIVIDE then dbms_output.put_line('Y can not be zero.');
        when others then dbms_output.put_line('Some Error.');
end;

-- Write a code to demonstrate TOO_MANY_ROWS error

declare
    v_rec hr.employees%rowtype;
begin
    select * into v_rec from hr.employees where department_id=20;
    dbms_output.put_line(v_rec.first_name);
exception
    when TOO_MANY_ROWS then dbms_output.put_line('Too many rows obtained by select query');
end;


-- Unnamed exception example

create table sample2026(sample_id int primary key, sample_desc varchar2(100) not null);

DECLARE
    error_null_value EXCEPTION;
    PRAGMA EXCEPTION_INIT(error_null_value, -1400);
    v_sid integer;
    v_desc varchar(100) default null;
BEGIN
    insert into sample2026(sample_id) values(90);
EXCEPTION 
    when error_null_value then DBMS_OUTPUT.PUT_LINE('Can not insert null');
    dbms_output.put_line(SQLCODE||' '||SQLERRM);
END;


-- USER DEFINED EXCEPTIONS

declare
    overlimit_total_salary EXCEPTION;
    cursor cur(dept integer) is select sum(salary) tot_sal from hr.employees where department_id=dept;
    v_maxlimit constant number default 100000;
    v_dept integer;
    v_tot_sal number;
begin
    v_dept:=&EnterDept;
    open cur(v_dept);
    fetch cur into v_tot_sal;
        if v_tot_sal > v_maxlimit then 
            RAISE overlimit_total_salary;
        else dbms_output.put_line('Total Salary for dept '||v_dept||' is '||v_tot_sal);
        end if;
    close cur;
exception 
    when overlimit_total_salary then dbms_output.put_line('Total Salary Overlimit Reached');
    dbms_output.put_line(SQLCODE||' '||SQLERRM);
    RAISE_APPLICATION_ERROR(-20100, 'Salary Overlimit Error');
end;

-- SUBPROGRAMS
    -- stored procedures. functions, triggers

-- stored procedures
/* ANONYMOUS BLOCK

declare

begin 

end;

*/

create or replace procedure p1 is
begin   
    delete from sample2026 where sample_id=900;
end;

exec p1;

select * from sample2026;


create table emp(eid integer primary key, fname varchar2(20), lname varchar2(20), 
    salary number, jobrole varchar2(20), dept integer);

insert into emp select employee_id, first_name, last_name, salary, job_id, department_id from hr.employees;


-- static stored procedure -> procedure without args
create or replace procedure p1 is
    v_dept integer;
begin   
    v_dept:=&EnterDept;
    update emp set salary=salary*1.1 where dept=v_dept;
end;

exec p1;

select * from emp where dept=40;


-- procedures with arguments
    -- IN      -> used to accept input from call [default]
    -- OUT     -> used to return back the output value to the call
    -- IN OUT  -> can be used as both IN and OUT type

-- IN type args

create or replace procedure find_tot_dept_sal(p_dept IN integer) is
    v_salary number;
begin
    select sum(salary) into v_salary from emp where dept=p_dept;
    dbms_output.put_line('Total Salary: '||v_salary);
end;

exec FIND_TOT_DEPT_SAL(60);

-- procedure with OUT type args
create or replace procedure get_avg_sal(p_avgsal OUT number) is
begin
    select avg(salary) into p_avgsal from emp;
end;

-- call
declare
    v_avgsal number;
begin
    GET_AVG_SAL(v_avgsal);
    DBMS_OUTPUT.PUT_LINE('Avg Salary: '||round(v_avgsal));
end;

-- Write a procedure code that finds all dept that has more avg than company average, use get_avg_sal procedure, 
    -- to make comparison from all dept starting 10 to 270 with incremrnt of 10

create or replace procedure find_defaulter_dept(p_start integer, p_end integer) is
    v_avgsal_company number;
    v_asal number;
begin
    get_avg_sal(v_avgsal_company);
    for v_dept in p_start..p_end by 10 loop
        select avg(salary) into v_asal from emp where dept=v_dept;
        if v_asal>v_avgsal_company then
            dbms_output.put_line('Department '||v_dept||' has more average than company.');
        end if;
    end loop;
end;

exec FIND_DEFAULTER_DEPT(10,270);


-- procedure with IN OUT args

create or replace procedure transform_text(p_text IN OUT varchar) is
begin
    p_text:=upper(trim(p_text));
end;

--
declare
    v_text varchar(100) default 'undefined';
begin
    v_text:='   this is hello world form plsql procedures   ';
    dbms_output.put_line('Length before transformation: '||length(v_text));
    TRANSFORM_TEXT(v_text);
    dbms_output.put_line(v_text);
    dbms_output.put_line('Length after transformation: '||length(v_text));
end;



-- write procedure code that accepts user account id and debit amount, performs debot of account if balance
    -- after debit remain atleast 1000, else deny debit and finally display balance.

create or replace procedure debit_account(p_accid number, p_amount number) is
    v_balance number;
begin
    select account_balance into v_balance from accounts where accid=p_accid;
    v_balance:=v_balance-p_amount;
    if v_balance>1000 then 
        update accounts set account_balance=v_balance where accid=p_accid;
        commit;
        dbms_output.put_line('Accoutn debited successfully, balance: '||v_balance);
    else 
        dbms_output.put_line('Insufficient balance!'); rollback;
    end if;
end;

exec debit_account(9001, 300);

select * from accounts;


-- propogating errors

create or replace procedure child_process(x in number, y in number) is
    z number;
begin
    z:=x/y;
    dbms_output.put_line('X/Y is '||round(z,2));
end;

--
create or replace procedure parent_process(a in number, b in number) is
begin
    dbms_output.put_line('Calling child process...');
    child_process(a, b);
    dbms_output.put_line('Child process execution successful!');
exception
    when zero_divide then dbms_output.put_line('Divide By Zero Error');
end;

exec parent_process(125, 7);

exec parent_process(125, 0);


-- Functions
    -- functions are special type of SP
    -- func can have only IN type args
    -- func always return a value
    -- func can call another func
    -- func CAN NOT call a SP
    -- func should not be used for DML or transactions

    -- SP can call SP, and SP can call a func

-- UDF -> user defined funcs


create or replace function find_index_substr(p_text in varchar, p_substr in varchar) return integer is
begin
    return instr(p_text, p_substr);
end;

declare
    v_text varchar(20):='hello plsql';
    v_substr varchar(20):='plsql';
    v_index integer:=0;
begin
    v_index:=find_index_substr(v_text, v_substr);
    dbms_output.put_line('Found at index: '||v_index);
end;

--
declare
    v_text varchar(20):='hello plsql';
    v_substr varchar(20):='plsql';
begin
    dbms_output.put_line('Found at index: '||find_index_substr(v_text, v_substr));
end;


select fname, find_index_substr(lower(fname), 'a') as found_a_index from emp;


select fname from emp where find_index_substr(lower(fname), 'a')>0;


-- Write function code that accepts salary & hike %age value as input and return salary in 
    -- $ currency format with x% hike

create or replace function salary_hike(p_salary in number, p_hike in number) return number is
begin
    return p_salary + ((p_salary*p_hike)/100);
end;

--
begin
    dbms_output.put_line(salary_hike(10000, 10));
end;

--
select fname, salary, salary_hike(salary, 5) as new_salary from emp
    where salary_hike(salary, 5)>10000;


-- Triggers
    -- Trigger are also special type of SP
    -- Trigger is invoked automatically based on an event
    -- Trigger is always associated to an event on some object

/*
create or replace trigger <name>
before|after <event [insert, update, delete]> on <object> for each row
begin
    -- exec/action code
end;
*/

create or replace trigger emp_update_msg
after update on emp for each row
begin
    dbms_output.put_line('Emp Table Record Updated...');
end;

update emp set salary=salary+100 where dept=30;


-- Trigger Example

drop table emplogtable;
drop sequence empseq;

create table emplogtable(logid int primary key, logtext varchar2(256), logdate date);

create sequence empseq start with 9001 increment by 1 nominvalue nomaxvalue nocycle nocache;

create or replace trigger emp_update_logging
after update on emp for each row
begin
    insert into emplogtable values(empseq.nextval, 'EMP record updated by '||user, sysdate);
end;

update emp set salary=salary+1000 where dept=20;


select * from emplogtable;

-- create delete trigger to entre logs
create or replace trigger emp_delete_logging
after delete on emp for each row
begin
    insert into emplogtable values(empseq.nextval, 'EMP record deleted by '||user, sysdate);
end;

delete from emp where dept=100;

--

-- :OLD and :NEW operator

-- create trigger that only allows update if new salary is more than old salary, else keep salary same

create or replace trigger check_salary_update 
before update on emp for each row
begin
    if :OLD.salary>:NEW.salary then 
        :NEW.salary:=:OLD.salary;
    end if;
end;

select * from emp where eid=120;

update emp set salary=12000 where eid=120;



-- Dynamic SQL Queries

-- dynamic query in procedure
declare
    v_tablename varchar2(50):='emp';
    v_columnname varchar2(30):='jobrole';
    v_val varchar2(20);
begin
    EXECUTE  IMMEDIATE 'select '||v_columnname||' from '||v_tablename||' where rownum=1' INTO v_val;
    dbms_output.put_line('First Value: '||v_val);
end;

-- usig bind variables

declare
    v_eid integer:=100;
    v_sql varchar2(256);
begin
    v_sql:='select fname from emp where eid=:id';
    EXECUTE IMMEDIATE v_sql USING v_eid;
end;

-- RISK : Decreased performance, more security risk



-- OBJECT TYPE
CREATE TYPE EMPDATA AS OBJECT(
        f_name varchar2(50),
        l_name varchar2(50),
        jobtype varchar2(20),
        salary_obtained number
    );

declare
    emp_data EMPDATA;
begin
    select fname, lname, jobrole, salary into emp_data from emp;
end;


-- Write a function code that accepts first name and last name from table and performs a check if both are 
    -- atleast 3 characters long or not

create or replace function check_names(p_fname varchar, p_lname varchar) return boolean is
begin
    if length(p_fname)>2 and length(p_lname)>2 then
        return TRUE;
    else return FALSE;
    end if;
end;

select fname, lname, check_names(fname, lname) as check_status from emp;