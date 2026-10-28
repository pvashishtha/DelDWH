-- PLSQL Basics Day 1

-- PLSQL Block

/*
DECLARE [optional]
    -- declare vars, obj, package, etc
BEGIN [MANDATORY]
    -- write SQL and PL block code
EXCEPTION [optional]
    -- handle exceptions
END; [MANDATORY]
*/

-- Hello World

BEGIN
    dbms_output.put_line('Hello World'); -- console output
END;


DECLARE
    v_message varchar(30) default 'Hello World';
BEGIN
    v_message := v_message || ' from PLSQL';
    dbms_output.put_line(v_message);
END;


-- User input

declare
    v_msg varchar(20);
begin
    v_msg := '&EnterMsg';
    dbms_output.put_line(v_msg);
end;


-- Write PLSQL block code to accept 2 integers from user and perform arithmetic operations

declare
    v_num1 INTEGER;
    v_num2 INTEGER;
begin
    v_num1:=&EnterNum1;
    v_num2:=&EnterNum2;
    dbms_output.put_line('Add: '||(v_num1+v_num2));
    dbms_output.put_line('Sub: '||(v_num1-v_num2));
    dbms_output.put_line('Div: '||(v_num1/v_num2));
    dbms_output.put_line('Mul: '||(v_num1*v_num2));
end;

-- constant & not null vars

declare
    v_pi CONSTANT NUMBER :=3.14;
begin
    v_pi:=3.1456789;
    dbms_output.put_line(v_pi);
end;

declare
    v_pi NUMBER NOT NULL :=0;
begin
    dbms_output.put_line(v_pi);
end;


-- %TYPE -> table_name.column_name%TYPE;

declare
    v_salary hr.employees.salary%type;
begin
    v_salary:='&Enter_Salary';
    dbms_output.put_line(v_salary);
end;

-- also declare another variable using datatype of previously declared variable

declare
    var1 number :=100;
    var2 var1%type :=200;
begin
        dbms_output.put_line('values: '||var1||' and '||var2);
end;

-- Boolean Variables
    -- accept values like TRUE, FALSE, NULL
    -- can be used in logical operations/comparisons
    -- can be returned by arithmetic, date or character expressions
declare
    flag boolean := true;
begin
    flag:=false;
    dbms_output.put_line('FLAG: '||to_char(flag));
end;


-- Write PLSQL block to read from user, name and designation, and print on screen

-- Write PLSQL block to accept user name and print in upper case

--

-- Variable Scope in nested blocks

declare
    varx integer :=10;
begin
    declare
        vary integer :=20;
    begin
        dbms_output.put_line('Inner Block');
        dbms_output.put_line('Value X: '||varx);
        dbms_output.put_line('Value Y: '||vary);
    end;
    dbms_output.put_line('Outer Block');
    dbms_output.put_line('Value X: '||varx);
    --dbms_output.put_line('Value Y: '||vary); -- not accessible in outer block, local to inner block
end;

--
declare
    varx integer :=10;
begin
    declare
        varx integer :=20;
    begin
        dbms_output.put_line('Inner Block');
        dbms_output.put_line('Value X: '||varx);
    end;
    dbms_output.put_line('Outer Block');
    dbms_output.put_line('Value X: '||varx);
end;

--
<<outer>>
declare
    varx integer :=10;
begin
    declare
        varx integer :=20;
    begin
        dbms_output.put_line('Inner Block');
        dbms_output.put_line('Value X: '||outer.varx);
    end;
    dbms_output.put_line('Outer Block');
    dbms_output.put_line('Value X: '||varx);
end;


-- DML opeartions in PLSQL block

create table devices(device_id int primary key, device_name varchar2(50), device_code number);
insert into devices values(101, 'smartphone', 90001);
insert into devices values(102, 'raspberrypi', 90008);
insert into devices values(103, 'camera', 90003);
insert into devices values(104, 'router', 90006);

select * from devices;

-- Insert

DECLARE
    v_id integer:=105;
    v_name varchar(30):='leddisplay';
    v_code number:=90009;
BEGIN
    insert into devices values(v_id, v_name, v_code);
END;

-- update
declare
    v_id integer:=105;
    v_name varchar(30):='television';
begin
    update devices set device_name=v_name where device_id=v_id;
end;

-- delete
declare
    v_id integer;
begin
    v_id:=&EnterID;
    delete from devices where device_id=v_id;
end;


-- SELECT statements

declare
    v_salary hr.employees.salary%type;
begin
    select salary into v_salary from hr.employees where employee_id=100;
    dbms_output.put_line('Salary: '||v_salary);
end;

-- Write PLSQL block to fetch & display the first name and job id of employee whose ID is entered by user.

declare
    v_id hr.employees.employee_id%type;
    v_name hr.employees.first_name%type;
    v_job hr.employees.job_id%type;
begin
    v_id:=&EnterID;
    select first_name, job_id into v_name, v_job from hr.employees where employee_id=v_id;
    dbms_output.put_line('First Name: '||v_name);
    dbms_output.put_line('Job ID: '||v_job);
end;


-- fetching entire record->  tablename%rowtype;
declare
    v_record hr.employees%ROWTYPE;
begin
    select * into v_record from hr.employees where employee_id=100;
    dbms_output.put_line('First Name: '||v_record.first_name);
    dbms_output.put_line('Salary: '||v_record.salary);
    dbms_output.put_line('Department : '||v_record.department_id);
end;

-- Accepting employee id from user, display first name, last name and phone number 

declare
    empid hr.employees.employee_id%type;
    v_record hr.employees%rowtype;
begin
    empid:=&EnterEmpID;
    select * into v_record from hr.employees where employee_id=empid;
    dbms_output.put_line(rpad('FIRST NAME',25,' ')||rpad('LAST NAME',25,' ')||rpad('PHONE',25,' '));
    dbms_output.put_line(rpad('-',70,'-'));
    dbms_output.put_line(rpad(v_record.first_name,25,' ')||rpad(v_record.last_name,25,' ')||rpad(v_record.phone_number,25,' '));
end;


-- Write PLSQL code that reads employee salary value from database based on ID provided, and analyse whether
    -- salary falls into Level 1, Level 2 or Level 3 on basis of following table:
    -- Level 1 -> 15000 to 25000
    -- Level 2 -> 8000 to 14999
    -- Level 3 -> 1000 to 7999
    -- Hint: Use CASE

declare
    empid hr.employees.employee_id%type;
    v_salary hr.employees.salary%type;
    v_level varchar(20);
begin
    empid:=&EnterEmpID;
    select salary into v_salary from hr.employees where employee_id=empid;
    CASE 
        when v_salary between 15000 and 25000 then v_level:='Level 1';
        when v_salary between 8000 and 14999 then v_level:='Level 2';
        when v_salary between 1000 and 7999 then v_level:='Level 3';
        else v_level:='Unknown';
    END CASE;
    dbms_output.put_line('Salary Type: '||v_level);
end;


-- CONTROL STRUCTURES
    -- IF THEN

declare
    v_num number;
begin
    v_num:=&EnterNum;
    IF v_num>10 THEN v_num:=v_num/10;
    END IF;
    dbms_output.put_line(v_num);
end;

-- IF THEN ELSE

declare
    v_num number;
begin
    v_num:=&EnterNumber;
    if v_num<0 then dbms_output.put_line('Negative Number');
    else dbms_output.put_line('Positive Number');
    end if;
end;

-- if-then-elsif

declare
    empid hr.employees.employee_id%type;
    v_salary hr.employees.salary%type;
    v_level varchar(20);
begin
    empid:=&EnterEmpID;
    select salary into v_salary from hr.employees where employee_id=empid;
    if v_salary between 15000 and 25000 then v_level:='Level 1';
    elsif v_salary between 8000 and 14999 then v_level:='Level 2';
    elsif v_salary between 1000 and 7999 then v_level:='Level 3';
    else v_level:='Invalid';
    end if;
    dbms_output.put_line('Salary Type: '||v_level);
end;


-- Write PLSQL code to accept marks form student and determine grade as per slab:
    -- 85 to 100 -> Grade A
    -- 70 to 84 -> Grade B
    -- 60 to 69 -> Grade C
    -- Below 60 -> Grade F
declare
    marks number :=0;
    grade varchar(20):='Grade X';
begin
    marks:=&EnterMarks;
    if marks between 85 and 100 then grade:='Grade A';
    elsif marks between 70 and 84 then grade:='Grade B';
    elsif marks between 60 and 69 then grade:='Grade C';
    else grade:='Grade F'; end if;
    dbms_output.put_line('Grade Obtained for '||marks||' is: '||grade);
end;

-- Read Data of employee from table and display eligibility to salary hike based on salary if it is less than 10000
declare
    v_salary number;
    v_eid integer:=179;
begin
    select salary into v_salary from hr.employees where employee_id=v_eid;
    if v_salary<10000 then dbms_output.put_line('Eligible');
    else DBMS_OUTPUT.PUT_LINE('Not Eligible');
    end if;
end;

-- Write PLSQL code that verifies whether employee whose ID is provided earn more than avg salary or not
declare
    v_salary number;
    v_avgsal number;
    v_eid integer:=179;
begin
    select avg(salary) into v_avgsal from hr.employees;
    select salary into v_salary from hr.employees where employee_id=v_eid;
    if v_salary<v_avgsal then dbms_output.put_line('Below Average');
    else DBMS_OUTPUT.PUT_LINE('Above Average');
    end if;
end;

-- Write PLSQL code to find count of employees earning less than average salary and determine whether the count
    -- is more than or less than 50% of total employees count
declare
    v_cnt integer;
    tot_count integer;
begin
    select count(*) into v_cnt from hr.employees where salary<(select avg(salary) from hr.employees);
    select count(*) into tot_count from hr.employees;
    if v_cnt<(tot_count/2) then dbms_output.put_line('Less than 50% earn below average');
    else DBMS_OUTPUT.PUT_LINE('More than 50% earn above average');
    end if;
end;

-- Create table for bank_accounts, allow customer to debit with certain amount. Allow debit only if balance
    -- after debit will be atleast 1000.

create table accounts(accid int primary key, account_balance number);
insert into accounts values(9001, 1750);
insert into accounts values(9002, 2300);
insert into accounts values(9003, 1100);
insert into accounts values(9004, 3400);

DECLARE
    v_amt number;
    v_balance number;
    v_accid integer;
BEGIN
    v_accid:=&EnterAccID;
    v_amt:=&EnterAmoutnToDebit;
    select account_balance into v_balance from accounts where accid=v_accid;
    if (v_balance-v_amt)>=1000 then
        update accounts set account_balance=(account_balance-v_amt) where accid=v_accid;
        commit;
        dbms_output.put_line('Debit Successfull, Balance: '||(v_balance-v_amt));
    else dbms_output.put_line('Insufficient Balance');
    rollback;
    end if;
END;

select * from accounts;



-- LOOP CONTROL

    -- SIMPLE LOOP
    -- WHILE LOOP
    -- FOR LOOP

-- Simple Loop

declare
    v_var integer:=1;
begin
    LOOP    
        EXIT WHEN v_var>5;
        dbms_output.put_line('Loop Var: '||v_var);
        v_var:=v_var+1;
    END LOOP;
end;


-- Write PLSQL code block to read records from employees table from ID 100 to 110 and print their name and salary

declare
    v_range integer default 100;
    v_rec hr.employees%rowtype;
begin
    LOOP    
        select * into v_rec from hr.employees where employee_id=v_range;
        dbms_output.put_line('Name: '||v_rec.first_name);
        dbms_output.put_line('Salary: '||v_rec.salary);
        dbms_output.put_line('-------------------');
        v_range:=v_range+1;
        EXIT WHEN v_range>110;
    END LOOP;
end;

-- Write PLSQL code using simple loop to all employees name comma separated.

declare
    v_range integer:=100;
    v_name varchar(30);
begin
    LOOP    
        select first_name into v_name from hr.employees where employee_id=v_range;
        dbms_output.put(v_name||',');
        v_range:=v_range+1;
        EXIT WHEN v_range>206;
    END LOOP;
    dbms_output.put_line(' ');
end;


-- While Loop

declare
    v_var integer:=1;
begin
    WHILE v_var<=5 LOOP
        dbms_output.put_line('Iteration: '||v_var);
        v_var:=v_var+1;
    END LOOP;
end;

-- Write PLSQL code that prints odd numbers in reverse order from 27 to 1.

declare
    v_var integer:=27;
begin
    while v_var>=1 loop
        dbms_output.put(v_var||', ');
        v_var:=v_var-2;
    end loop;
    dbms_output.put_line(' ');
end;


-- Write PLSQL code to accept integer from user and find & print factorial of that integer.
declare
    v_num integer:=1;
    v_fact integer:=1;
    v_var integer:=2;
begin
    v_num:=&EnterNumber;
    while v_var<=v_num loop
        v_fact:=v_fact*v_var;
        v_var:=v_var+1;
    end loop;
    dbms_output.put_line('Factorial of '||v_num||' is: '||v_fact);
end;

-- Write code to check whether number is prime or not
declare
    v_num integer:=1;
    v_var integer:=2;
begin
    v_num:=&EnterNumber;
    while v_var<=(v_num/2+1) loop
        if mod(v_num, v_var) =0 then
            dbms_output.put_line('Not Prime');
        end if;
        v_var:=v_var+1;
        exit when mod(v_num, v_var)=0;
    end loop;
    if v_var>(v_num/2+1) then 
        dbms_output.put_line('Prime');
    end if;
end;

-- FOR LOOP

declare
    --v_var integer:=1;
begin
    FOR v_var IN 1..5 LOOP
        dbms_output.put_line('Iterator: '||v_var);
    END LOOP;
end;

-- reverse order loop
declare
    --v_var integer:=1;
begin
    FOR v_var IN REVERSE 1..5 LOOP
        dbms_output.put_line('Iterator: '||v_var);
    END LOOP;
end;


-- Write PLSQL for loop code to read and print all employee first name

begin
    for fname in (select first_name from hr.employees where department_id=30) loop
        DBMS_OUTPUT.PUT_LINE(fname.first_name);
    end loop;
end;

--

begin
    for emp in (select first_name, salary from hr.employees where department_id=30) loop
        DBMS_OUTPUT.PUT_LINE(emp.first_name);
        DBMS_OUTPUT.PUT_LINE(emp.salary);
        DBMS_OUTPUT.PUT_LINE('===================');
    end loop;
end;


-- Using for loop find factorial of number

declare
    v_fact integer:=1;
    v_num integer:=1;
begin
    v_num:=&EnterNumber;
    for i in 2..v_num loop
        v_fact:=v_fact*i;
    end loop;
    dbms_output.put_line('factorial of '||v_num||' is '||v_fact);
end;