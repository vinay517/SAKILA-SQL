# First and last names from actor

select first_name, last_name from actor

# first and last name of each actor in single column in upper case letters 
# and name it as Actor name

select (upper(concat(first_name, ' ', last_name))) as Actor_Name from actor

# id number, first name and last name of an actor of whom you know only first name 'joe' 

select actor_id, first_name, last_name 
from actor
where lower(first_name) = lower('joe')

# Last names of actors whose name conatins GEN

select last_name 
from actor
where upper(last_name) like '%GEN%'

# all actors whose last names contain the letters LI. order by last name and first name

select * 
from actor
where upper(last_name) like '%LI%'
order by last_name, first_name

# country id and country and get these countries

SELECT * 
FROM `country`
where country in ('Afghanistan','Bangladesh','China')

# adding column to the table actor named description and use data type BLOB

# main diff bet TEXT and BLOB is that BLOB is stored off the tabvle with the table just having
# the pointer to the location of actual storage whereas VARCHAR is stored inline with the table

SELECT * 
FROM actor

ALTER TABLE actor
add column description BLOB

# dropping column description

alter table actor
drop column description

# list the last name of actors and how many actors have that last name

select last_name, count(last_name)
from actor
group by last_name

# list the last name of actors and how many actors have that last name but only for name that are shared bt at least two actors

select last_name, count(last_name)
from actor
group by last_name
having count(last_name) > 2

# actor harpo williams was accidentally entered in actor table as groucho williams. fix it

update actor set first_name = 'HARPO', last_name = 'WILLIAMS'
where first_name = 'GROUCHO' and last_name = 'WILLIAMS'

# changing it back

update actor set first_name = 'GROUCHO' 
where first_name = 'HARPO' and last_name = 'WILLIAMS'

# locate the schema of the address table

SHOW CREATE TABLE address

# join to display the first and last name and address of each staff member with staff and address tables

select first_name, last_name, a.*
from staff s 
LEFT join address a on s.address_id = a.address_id

# join to display total amount rung up by each staff in august of 2005 with staff and payment tables

select s.first_name, s.last_name, sum(amount)
from staff s 
left join payment p on s.staff_id = p.payment_id
where month(payment_date) = 08 and year(payment_date) = '2005'
GROUP by s.first_name, s.last_name

# each film and no of actors listed for that file use fim_Actor and film

select f.title, count(actor_id) 
from film f 
join film_actor a on f.film_id = a.film_id
group by f.title
order by count(actor_id) desc

# how many copies of hunchback impossible exist in the inventory system

select title, count(inventory_id) 
from film f 
join inventory i on f.film_id = i.film_id  
where title = 'Hunchback Impossible'
group by title

# payment and customer tables to find th total paid by each customer

select c.last_name, c.first_name, sum(p.amount)
from customer c
join payment p on c.customer_id = p.customer_id
group by c.last_name, c.first_name 
order by c.last_name

# use subqueries to display the titles of movies starting with letters k and q whose language is english

# select * from language

select title 
from film 
where (title like 'K%' 
or title like 'Q%')
and language_id in (select language_id from language where language_id = '1')

# actors acted inn alone trip

select actor.*
from actor where actor_id in 
(select fa.actor_id from film_actor fa where film_id in 
 (select film_id FROM film where title = 'Alone Trip'))

# names and emai address of all canadian customer

select * from customer
where address_id in 
(select address_id from address where city_id in 
 (select city_id from city where country_id in ( select country_id from country where lower(country) = 'canada'
 )
)
)


# all family films

select title from film
where film_id in (select film_id from film_category where category_id in (select category_id from category where name = 'Family'))

# frequently rented movies in descending order

select f.film_id, f.title, a.*
from film f
join( select i.film_id, count(r.rental_id) as cnt_rented
from rental r
join inventory i on r.inventory_id = i.inventory_id
group by i.film_id

) a on a.film_id = f.film_id
order by b.cnt_rented desc

# total business each store brought in 

select s.store_id, a.sales
from store s 
join( 
select c.store_id, sum(p.amount) as sales
from customer c
join payment p on c.customer_id = p.customer_id
group by c.store_id
) a
on a.store_id = s.store_id
order by s.store_id 

# display store_id, city and country along with sales

select A.*, B.sales 
from (
	select sto.store_id, cit.city, cou.country
	from store sto
	left join address adr
	on sto.address_id = adr.address_id
	join city cit
	on adr.city_id = cit.city_id
	join country cou
	on cit.country_id = cou.country_id
) A
join (
	select cus.store_id, sum(pay.amount) sales
	from customer cus
	join payment pay
	on pay.customer_id = cus.customer_id
	group by cus.store_id
) B
on A.store_id = B.store_id
order by a.store_id

# top 5 genres in gross revenue in descending order

select cat.name category_name, sum( IFNULL(pay.amount, 0) ) revenue
from category cat
left join film_category flm_cat
on cat.category_id = flm_cat.category_id
left join film fil
on flm_cat.film_id = fil.film_id
left join inventory inv
on fil.film_id = inv.film_id
left join rental ren
on inv.inventory_id = ren.inventory_id
left join payment pay
on ren.rental_id = pay.rental_id
group by cat.name
order by revenue desc
limit 5;

# creating and dropping above query as view 

create view top_five_genres as 
select cat.name category_name, sum( IFNULL(pay.amount, 0) ) revenue
from category cat
left join film_category flm_cat
on cat.category_id = flm_cat.category_id
left join film fil
on flm_cat.film_id = fil.film_id
left join inventory inv
on fil.film_id = inv.film_id
left join rental ren
on inv.inventory_id = ren.inventory_id
left join payment pay
on ren.rental_id = pay.rental_id
group by cat.name
order by revenue desc
limit 5;

select * from top_five_genres;

drop view top_five_genres;































 