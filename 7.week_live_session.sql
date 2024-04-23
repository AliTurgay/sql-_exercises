--UNION
--SQL'de UNION, birden fazla SELECT sorgusundan gelen sonuçları birleştirmek için kullanılan bir operatördür. UNION, tek bir tablo gibi görünen ve her SELECT sorgusundan gelen satırları içeren bir tablo oluşturur.

--iki tabloyu birleştirip tekil satırları döndürmek için union distinct

select first_name,
last_name
from employees --1.şirketimin çalışanları

union distinct

select first_name,
last_name
from dependents -- 2.şirketimin çalışanları

-----------------------------------------------------------------------------
select first_name,
last_name
from employees

union distinct

select first_name,
last_name
from employees


--iki tabloyu birleştirip tüm satırları döndürmek için union all

select first_name,
last_name
from employees --1.şirketimin çalışanları

union all 

select first_name,
last_name
from dependents


--

select first_name,
last_name,
hire_date
from employees --1.şirketimin çalışanları

union all 

select first_name,
last_name,
null as hire_date
from dependents


--'yıl,ay,gün' formatındaki tarihi 'gün,ay,yıl' formatına dönüştürme
select to_char(hire_date, 'dy-mon-yyyy')
from employees

