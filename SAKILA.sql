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






























 