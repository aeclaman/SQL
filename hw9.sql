use sakila;

-- 1a.
select first_name, last_name from actor;

-- 1b.
select concat(upper(first_name), ' ', upper(last_name)) as 'Actor Name' from actor;

-- 2a.
select actor_id, first_name, last_name from actor
where first_name = 'Joe';

-- 2b.
select * from actor
where last_name like '%gen%';

-- 2c. 
select * from actor
where last_name like '%li%'
order by last_name, first_name;

-- 2d. 
select country_id, country from country
where country in ('Afghanistan', 'Bangladesh', 'China');

-- 3a. 
ALTER TABLE actor
ADD COLUMN description blob;

-- 3b. 
ALTER TABLE actor
DROP COLUMN description;

-- 4a. 
select last_name, count(first_name) as 'Total with Same Last Names' FROM (SELECT DISTINCT 
  last_name,
  first_name
from actor) as temp
group by last_name;

-- 4b. 

select last_name, total from (
	select last_name, count(first_name) as total FROM (SELECT DISTINCT 
	last_name,
	first_name
	from actor) as temp1
	group by last_name) as temp2
where total > 1;

-- 4c. 
update actor
set first_name = 'HARPO'
where last_name = 'WILLIAMS' and first_name = 'GROUCHO';

-- 4d. 
update actor 
set first_name = 'GROUCHO'
where first_name = 'HARPO';

-- 5A. 
show create table address;

-- 6a. 
select s.first_name, s.last_name, a.address
from staff as s
inner join address as a on
s.address_id = a.address_id;

-- 6b. 
select s.first_name, s.last_name, sum(p.amount)
from payment as p
inner join staff as s on 
s.staff_id=p.staff_id
where p.payment_date between '2005-08-01 00:00:00' and '2005-08-31 23:59:59'
group by p.staff_id;

-- 6c. 
select f.title, count(fa.actor_id)
from film as f
left join film_actor as fa on 
f.film_id=fa.film_id
group by f.film_id;

-- 6d. 
select count(film_id) from inventory
where film_id = (select film_id from film where title = 'Hunchback Impossible');

-- 6e.
select c.first_name, c.last_name, sum(p.amount)
from payment as p
inner join customer as c on 
c.customer_id=p.customer_id
group by p.customer_id
order by c.last_name;

-- 7a.
select title from film
where language_id = (select language_id from language where name = 'English')
and title like 'K%' or title like 'Q%';

-- 7b. 
select first_name, last_name from actor
where actor_id in (select actor_id from film_actor where film_id =
	(select film_id from film where title = 'Alone Trip'));
    
-- 7c. 
select c.first_name, c.last_name, c.email 
from customer as c
inner join address as a on c.address_id=a.address_id
inner join city on a.city_id=city.city_id
inner join country as cy on city.country_id=cy.country_id
where cy.country='Canada';

-- 7d. 
select title from film where film_id in (
	select film_id from  film_category where category_id = (
			select category_id from category
			where name = 'Family'));
            
-- 7e. 
select f.title, count(r.inventory_id) as count
from inventory as i
inner join rental as r on 
r.inventory_id=i.inventory_id
inner join film as f on 
f.film_id=i.film_id
group by r.inventory_id
order by count desc;

-- 7f. 
select store.store_id, sum(amount) as total from payment
inner join staff on
payment.staff_id=staff.staff_id
inner join store on 
store.store_id=staff.store_id
group by staff.store_id, payment.staff_id;

-- 7g. 
select store.store_id, city.city, country.country
from store
inner join address as a on 
a.address_id=store.address_id
inner join city on 
city.city_id=a.city_id
inner join country on
country.country_id=city.country_id;

-- 7h. 
select cat.name, sum(pay.amount) as total
from category as cat
inner join film_category as fc on
fc.category_id=cat.category_id
inner join inventory as inv on 
inv.film_id=fc.film_id
inner join rental as r on
r.inventory_id=inv.inventory_id
inner join payment as pay on
pay.rental_id=r.rental_id
group by cat.name
order by total desc
limit 5;

-- 8a. 
create view top_five_genres as
select cat.name, sum(pay.amount) as total
from category as cat
inner join film_category as fc on
fc.category_id=cat.category_id
inner join inventory as inv on 
inv.film_id=fc.film_id
inner join rental as r on
r.inventory_id=inv.inventory_id
inner join payment as pay on
pay.rental_id=r.rental_id
group by cat.name
order by total desc
limit 5;

-- 8b.
select * from top_five_genres;

-- 8c. 
drop view if exists top_five_genres;
 

