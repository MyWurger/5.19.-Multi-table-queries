-- Задача 1. Вывести название отдела, которым руководит менеджер 108 и название города, в котором расположен отдел.

select manager_id, department_name, city
from departments d join locations l using (location_id)
where manager_id = 108;


-- Задача 2. Вывести названия отделов и названия товаров, которые продавали сотрудники этих отделов.
-- Вариант а: вывести только те отделы, сотрудники которых продавали товары

select distinct department_name, product_name
from departments d 
join employees e on (d.department_id = e.department_id)
join orders o on (e.employee_id = o.salesman_id)
join order_items oi on (o.order_id = oi.order_id)
join products p on (oi.product_id  = p.product_id)


-- Вариант б: вывести все отделы.

select distinct department_name, product_name
from departments d 
left join employees e on (d.department_id = e.department_id)
left join orders o on (e.employee_id = o.salesman_id)
left join order_items oi on (o.order_id = oi.order_id)
left join products p on (oi.product_id  = p.product_id)


-- Задача 3. Вывести даты продаж, осуществленных в ноябре 2019 года, и общую сумму продаж за каждую дату.

select order_date, sum(quantity * unit_price)
from orders o 
join order_items using (order_id)
where to_char(order_date, 'MM-YYYY') = '11-2019'
group by order_date


-- Задача 4. Выведите количество сотрудников и суммарную зарплату сотрудников, работающих в каждом городе. Должны быть выведены данные обо всех городах из таблицы Locations.

select city, count(employee_id), sum(salary)
from locations l 
left join departments using(location_id)
left join employees e using (department_id)
group by city
order by count(employee_id) desc


-- Задача 5. Вывести данные о сотрудниках, у которых сумма продаж более чем в 50 раз больше зарплаты, которую они получают.

select employee_id, first_name, last_name, salary, sum(unit_price * quantity) as sale_sum
from employees e
join orders o on (e.employee_id = o.salesman_id)
join order_items oi using (order_id)
group by employee_id, first_name, last_name
having sum(unit_price * quantity) > 50*salary
order by employee_id desc;


-- Задача 7. Выведите данные зарплате сотрудников, с итоговыми строками, кото-рые содержат суммарную зарплату по каждой должности, отделу и городу. Ис-ключить данные о сотрудниках, которые работают в США (country_id ='US').

select job_id, department_id, city, sum(salary)
from departments d
full join locations l using (location_id)
full join employees e using (department_id)
where country_id!= 'US' and department_id is not null
group by grouping sets (job_id, department_id, city)
order by(job_id, department_id, city)