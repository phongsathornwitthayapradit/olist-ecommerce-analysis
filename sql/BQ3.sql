/*BQ3 — Product Analysis

BQ3.1 Top 10 หมวดสินค้าที่มี revenue สูงสุด?
BQ3.2 หมวดสินค้าไหนได้ review score ต่ำที่สุด (minimum 50 orders)?
BQ3.3 หมวดสินค้าไหนมี freight ratio (freight/price) สูงที่สุด?
BQ3.4 หมวดสินค้าที่ขายเยอะ แต่ได้ review ต่ำ มีอะไรบ้าง?*/

-- BQ 3.1
select c.product_category_name_english ,SUM(a.price) total_price
from order_items a
left join products b on a.product_id = b.product_id 
left join product_category_name_translation c on b.product_category_name = c.product_category_name 
WHERE a.price > 0
  AND c.product_category_name_english IS NOT NULL
group by c.product_category_name_english 
order by total_price desc 
LIMIT 10

-- BQ 3.2
select 
product_category_name_english as product_name 
,ROUND(avg(review_score),2) avg_score
,COUNT(a.order_id) count_order
from order_items a
left join order_reviews b on a.order_id = b.order_id 
left join products c on a.product_id = c.product_id 
left join product_category_name_translation d on c.product_category_name = d.product_category_name 
WHERE a.price > 0
  AND d.product_category_name_english IS NOT NULL
group by product_category_name_english 
HAVING count_order >= 50
order by ROUND(avg(review_score),2) asc


-- BQ 3.3
select b.product_category_name_english as prod_name 
,ROUND(SUM(a.freight_value)/SUM(a.price),2) as ratio
from order_items a
left join (
select distinct
product_id,b.product_category_name_english 
from products a left join product_category_name_translation b on a.product_category_name = b.product_category_name) b
on a.product_id = b.product_id 
WHERE a.price > 0
  AND b.product_category_name_english IS NOT NULL
group by b.product_category_name_english 
order by ratio desc

-- BQ 3.4
SELECT
    d.product_category_name_english AS category,
    COUNT(DISTINCT a.order_id)      AS total_orders,
    ROUND(AVG(c.review_score), 2)   AS avg_review_score
FROM order_items a
JOIN products b       ON a.product_id = b.product_id
JOIN order_reviews c  ON a.order_id = c.order_id
JOIN product_category_name_translation d
                      ON b.product_category_name = d.product_category_name
JOIN orders o         ON a.order_id = o.order_id
WHERE o.order_status = 'delivered'
  AND d.product_category_name_english IS NOT NULL
GROUP BY category
HAVING total_orders >= 1000      
  AND avg_review_score <= 3.5   
ORDER BY avg_review_score asc;
