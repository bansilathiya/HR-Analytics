-- DATA CLEANING

create database projects;

use projects;

select * from hr;

alter table hr 
change column ï»¿id emp_id varchar(20) null;

describe hr;

select birthdate from hr;

set sql_safe_updates=0;

update hr
set hire_date = case
when hire_date like '%/%' then date_format(Str_to_date (hire_date,'%m/%d/%Y'),'%Y-%m-%d')
when hire_date like '%-%' then date_format(Str_to_date (hire_date,'%m-%d-%Y'),'%Y-%m-%d')
else null
end;

alter table hr 
modify column birthdate date;

update hr 
set termdate = date(str_to_date(termdate,'%Y-%m-%d %H:%i:%s UTC'))
where termdate is not null and termdate!='';

select termdate from hr;

alter table hr 
modify column termdate date;

alter table hr 
modify column hire_date date;

alter table hr add column age int;

select * from hr;

update hr
set age = timestampdiff(YEAR,birthdate,CURDATE());

select birthdate,age from hr;

select min(age) as youngest, max(age) as oldest from hr;

select count(*) from hr where age<18;


-- 1)GENDER BREAKDOWN OF EMPLOYEE
select gender , count(*) as count
from hr 
where age>=18 and termdate = ''
group by gender;

-- 2)RACE BREAKDOWN OF EMPLOYEE
select race , count(*)as count
from hr 
where age>=18 and termdate=''
group by race
order by count(*)desc;

-- 3)AGE DISTRIBUTION OF EMPLOYEE
select 
min(age)as youngest,
max(age)as oldest 
from hr 
where age>=18 and termdate='';

select 
case 
when age>=18 and age<=24 then '18-24'
when age>=25 and age<=34 then '25-34'
when age>=35 and age<=44 then '35-44'
when age>=45 and age<=54 then '44-54'
when age>=55 and age<=64 then '55-64'
else '65+'
end as age_group,
count(*)as count
from hr 
where age >=18 and termdate =''
group by age_group
order by age_group;

select 
case 
when age>=18 and age<=24 then '18-24'
when age>=25 and age<=34 then '25-34'
when age>=35 and age<=44 then '35-44'
when age>=45 and age<=54 then '44-54'
when age>=55 and age<=64 then '55-64'
else '65+'
end as age_group,gender,
count(*)as count
from hr 
where age >=18 and termdate =''
group by age_group,gender
order by age_group,gender;

-- 4)EMPLOYEE WORK AT HEADQUARTERS VERSUS REMOTE LOCATIONS
select location,count(*)as count
from hr
where age>=18 and termdate=''
group by location;

-- 5)AVERAGE LENGTH OF EMPLOYMENT FOR EMPLOYEE WHO HAVE BEEN TERMINATED
select
avg(datediff(termdate,hire_date))/365 as avg_length_employement
from hr 
where termdate<= curdate()and termdate <> ''and age>=18; 

-- 6)GENDER DISTRIBUTION ACROSS DEPARTMENTS 
select department,gender,count(*)as count
from hr 
where age>=18 and termdate = ''
group by department , gender
order by department;

-- 7)DISTRIBUTION OF JOB TITLES ACROSS THE COMPANY
select jobtitle , count(*) as count
from hr 
where age>=18 and termdate=''
group by jobtitle
order by jobtitle desc;

-- 8) HIGHEST TURNOVER RATE - DEPARTMENT
SELECT department, 
       total_count,
       terminated_count,
       terminated_count / total_count AS termination_rate
FROM (
    SELECT department,
           COUNT(*) AS total_count,
           SUM(CASE 
                   WHEN termdate <> '' AND termdate <= CURDATE() 
                   THEN 1 ELSE 0 
               END) AS terminated_count
    FROM hr 
    WHERE age >= 18
    GROUP BY department
) AS subquery 
ORDER BY termination_rate DESC;

-- 9)DISTRIBUTION OF EMPLOYEES ACROSS LOCATION BY CITY AND STATE
select location_state, count(*)as count
from hr 
where age>=18 and termdate=''
group by location_state
order by count desc;

-- 10)COMPANY EMPLOYEE COUNT CHANGED OVER TIME BASED ON HIRE AND TEAM DATES
select 
year,
hires,
terminations,
hires - terminations as net_change,
round((hires - terminations)/hires*100,2)as net_change_percent
from(
select year(hire_date) as year,
count(*)as hires,
sum(case when termdate<>''and termdate<=curdate() then 1 else 0 end) as terminations
from hr 
where age >=18
group by year(hire_date)
)as subquery
order by year asc;

-- 11)TENURE DISTRIBUTION FOR EACH DEPARTMENT
select department , round(avg(datediff(termdate,hire_date)/365),0)as avg_tenure
from hr
where termdate<= curdate() and termdate <> ''and age>=18
group by department;









