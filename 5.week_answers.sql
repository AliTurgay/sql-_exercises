--QUESTIONS : 

--Bölge bazlı ülke sayısını hesaplayınız.
select region_id,
count(*) 
from countries 
group by region_id;

select region_id,
count(distinct country_id) as country_count 
from countries 
group by 1;

--En fazla departmanın olduğu lokasyon hangisidir?

SELECT location_id,
count(department_id) as department_count
FROM departments
 --WHERE komutu fromdan sonra, burada yazılır.
 GROUP BY 1
 ORDER BY 2 DESC
 LIMIT 1

--Departman ve job_id bazlı toplam maaş tutarlarını hesaplayınız.

SELECT department_id,
       job_id,
       SUM (salary) AS total_salary
  FROM employees
 GROUP BY 1,
          2
    
--Maaş aralığı 10000-15000 birim olan kişiler en fazla hangi departmanda çalışmaktadır?

SELECT department_id,

       count(employee_id) AS employee_count
  FROM employees
 WHERE salary BETWEEN 10000 AND 15000
 GROUP BY 1  
 ORDER BY employee_count DESC
 LIMIT 1

--100 id'li managerin ekibinde çalışan kişilerin ortalama maaşı nedir?

SELECT avg(salary) AS avg_salary
  FROM employees
 WHERE manager_id = 100;
 

--Posta kodu 26192 olan lokasyondaki departmanlarda çalışan kişilerin ortalama maaşı nedir?
--location tablo(postal_code) (location_id)--> departments tablo (location_id) (department_id)--> employees


SELECT 
employee_id,
( avg(salary),2) as avg_salary
  FROM employees 
  where department_id IN 
  (
      select department_id from departments
      where location_id IN
      (
          select location_id from locations
          where postal_code='26192'
      )
  )
  group by employee_id
