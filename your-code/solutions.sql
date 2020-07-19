use publications;
##########################

# First part, some tries in class
SELECT * from roysched;

SELECT * from titles;

SELECT * from titleauthor;

SELECT * from authors;

SELECT * from sales;

# Step 1: Determine Sales
# use title_id

SELECT s.qty, s.title_id
from sales s;

SELECT t.title_id, t.price, t.royalty
from titles t;

SELECT a.title_id, a.au_id, a.royaltyper 
from titleauthor a;

create table chal_1 SELECT s.qty, s.title_id,t.price, t.royalty, a.au_id, a.royaltyper 
from sales s
left join titles t ON t.title_id =s.title_id
left join titleauthor a ON a.title_id = s.title_id
; 

# look out for duplicates with "left join"
# Result CAN have more rows than rows of left table after join
# 

Select * 
from chal_1;

# Select count(*) From
# ( Javier) as alias

create table chall_1 SELECT s.qty, s.title_id,
t.price, t.advance, t.royalty, a.au_id, a.royaltyper 
from sales s
left join titles t ON t.title_id =s.title_id
left join titleauthor a ON a.title_id = s.title_id
; 

-- SELECT au_id, SUM(price*qty(royalty/100)*(royaltyper/100))
-- from chall_1
-- Group by au_id;

###################### Challenge 1


create temporary table tot_roy_adv_per_title_auth SELECT 
    s.title_id,
    s.qty,
    t.price,
    t.royalty,
    t.advance,
    a.royaltyper,
    a.au_id,
    s.qty * t.price * t.royalty / 100 * a.royaltyper / 100 AS tot_roy,
    t.advance * a.royaltyper / 100 AS tot_adv
FROM
    sales s
        LEFT JOIN
    titles t ON t.title_id = s.title_id
        LEFT JOIN
    titleauthor a ON a.title_id = s.title_id
; 


create temporary table turtoise SELECT 
    au_id, 
    title_id, 
    SUM(tot_roy) sum_tot_roy, 
    AVG(tot_adv) tot_adv_ta
FROM
    tot_roy_adv_per_title_auth
GROUP BY au_id , title_id;

###############
create temporary table jellyfish Select au_id, 
SUM(sum_tot_roy) as roy,
SUM(tot_adv_ta) as adv

from turtoise
group by au_id ;

############
Select au_id, roy + adv as total_prof
from jellyfish
order by total_prof desc
limit 3;

######## Challenge 2

# try it with subqueries
Select s.title.id, 
s.au_id,
t.advance * ta.royaltyper/100 as advance,
t.price * s.qty* t.royalty/100* ta.royaltyper/100 as sales_royalty
from sales s
where title.id IN
(Select title.id from titleauthor ta) 
;




select prod_name from products
where id IN
(select prod_id from transactions
where MONTH(date_sold) = 6);




# Challenge 3

create table most_profiting_authors Select au_id, roy + adv as total_prof
from jellyfish
order by total_prof desc
limit 3;

