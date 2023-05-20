USE Sakila;


## 1. Select the first name, last name, and email address of all the customers who have rented a movie.

select concat(c.first_name," ", c.last_name), c.email, count(r.rental_id) as num_rentals
from customer c
join rental r
using (customer_id)
group by customer_id
having num_rentals > 0; #Not needed, but just to make sure we do what is asked.

## 2. What is the average payment made by each customer (display the customer id, customer name (concatenated), and the average payment made).
select customer_id, concat(c.first_name," ", c.last_name) as name, concat(round(avg(p.amount),2),"$") as avg_payment
from customer c
join payment p
using (customer_id)
group by customer_id; #Not needed, but just to make sure we do what is asked.

## 3. Select the name and email address of all the customers who have rented the "Action" movies.
-- Write the query using multiple join statements --
select distinct concat(c.first_name," ", c.last_name) as name,  c.email
from customer c
join rental r
using (customer_id)
join inventory i
using (inventory_id)
join film f
using (film_id)
join film_category fc
using (film_id)
join category cat
using (category_id)
where cat.name = "Action";

-- Write the query using sub queries with multiple WHERE clause and IN condition --
select distinct concat(first_name," ", last_name) as name, email
from customer
where customer_id in (
select customer_id from rental 
where inventory_id in (
select inventory_id from inventory
where film_id in (
select film_id from film
where film_id in (
select film_id from film_category
where category_id in (
select category_id from category
where name = "Action"))))); 

-- Verify if the above two queries produce the same results or not --
# We have the same value sin both queries, as the number of rows (names and emails) is the same (498)


## 4. Use the case statement to create a new column classifying existing columns as either or high value transactions based on the amount of payment. 
## If the amount is between 0 and 2, label should be low and if the amount is between 2 and 4, the label should be medium, and if it is more than 4, 
## then it should be high.

select *, 
	case when amount < 2 then "Low" when amount between 2 and 4 then "Medium" when amount > 4 then "High" end as 'Value'
 from payment;