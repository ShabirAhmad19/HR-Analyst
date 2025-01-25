Use hr_analyst;
desc hr_1; 
desc hr_2;
show tables;
select * from hr_1;

----- KPI 1. - Department wise average attrition rate -----

select department, 
concat(format(count(case when attrition = 'Yes' then 1 end) / count(*) *100, 2), '%')
as attrition_rate 
from hr_1
group by department;

----- KPI 2. Average Hourly Rate of Male reaserch Scientist -----

create table Projectdata as select * from hr_1 join hr_2 
on hr_1.employeenumber = hr_2.`employee ID`;
select * from projectdata; 

select jobrole, format(avg(hourlyrate),2) as Avg_HourlyRate,Gender from projectdata
where upper(jobrole)='research scientist' and upper(gender)='male'
group by jobrole, gender; 

show tables;

Rename table projectdata to old_projectdata;
----- KPI 3. Attrition Rate Vs department wise Monthly income stats -----

select department, format(avg(case when attrition = 'yes' then monthlyIncome end), 2)
as avg_monthly_income,
concat(format(count(case when attrition = 'Yes' then 1 end) / count(*) *100,2), '%') 
as attrition_Rate
from projectdata group by department; 
 
----- KPI 4. Average Working Years for each departments -----

Select department, avg(TotalWorkingYears) as avg_working_years
from projectdata group by department; 

----- KPI 5. Job role Vs Work Life balance -----

select ifnull (JobRole, 'Total') as JobRole,
count(case when workLifebalance = 1 then 1 end) as Bad_1,
count(case when workLifebalance = 2 then 1 end) as Fair_2,
count(case when workLifebalance = 3 then 1 end) as Good_3,
count(case when workLifebalance = 4 then 1 end) as Excellent_4,
count(*) as total_count
from projectdata
group by JobRole with rollup; 

----- KPI 6. Attrition Rate Vs Years since Last Promotion Relation -----
select Department,
concat(
format(
count(case when YearsSinceLastPromotion between 0 and 5 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion between 0 and 5 then 1 end) * 100, 2), '%')
as '0-5 Years',
concat(
format(
count(case when YearsSinceLastPromotion between 6 and 10 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion between 6 and 10 then 1 end) * 100, 2), '%')
as '6-10 Years',
concat(
concat(
format(
count(case when YearsSinceLastPromotion between 11 and 15 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion between 11 and 15 then 1 end) * 100, 2), '%')
as '11-15 Years',
concat(
format(
count(case when YearsSinceLastPromotion between 16 and 20 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion between 16 and 20 then 1 end) * 100,2), '%')
as '16-20 Years',
concat(
format(
count(case when YearsSinceLastPromotion between 21 and 25 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion between 21 and 25 then 1 end) * 100, 2), '%')
as '21-25 Years',
concat(
format(
count(case when YearsSinceLastPromotion between 26 and 30 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion between 26 and 30 then 1 end) * 100, 2), '%')
as '26-30 Years',
concat(
format(
count(case when YearsSinceLastPromotion > 30 and attrition = 'Yes' then 1 end) /
count(case when YearsSinceLastPromotion > 30 then 1 end) * 100, 2), '%')
as 'Above 30 Years'
from projectdata
group by Department;

