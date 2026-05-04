/*BQ4 — Delivery Analysis

BQ4.1 avg delivery days โดยรวมเป็นกี่วัน และ late rate กี่ %?
BQ4.2 รัฐไหนได้รับของช้าที่สุดและเร็วที่สุด?
BQ4.3 เดือนไหนมี late delivery rate สูงสุด?
BQ4.4 order ที่ส่งช้า vs ตรงเวลา review score ต่างกันมากแค่ไหน?
 * */

-- BQ 4.1
WITH T1 as (
select (JULIANDAY(STRFTIME('%Y-%m-%d',order_delivered_customer_date)) - JULIANDAY(STRFTIME('%Y-%m-%d',order_delivered_carrier_date))) day_diff
,CASE WHEN order_estimated_delivery_date < order_delivered_customer_date THEN 'Late' ELSE 'on time' END AS Late_n
from orders)
select 
Late_n
,AVG(day_diff) avg_day_deli
,ROUND(COUNT(*)*100.00/SUM(COUNT(*)) OVER(),2) AS c_rate
from T1
group by Late_n

-- BQ 4.2
select 
b.customer_state 
,MIN((JULIANDAY(STRFTIME('%Y-%m-%d',order_delivered_customer_date)) - JULIANDAY(STRFTIME('%Y-%m-%d',order_purchase_timestamp)))) min_day_diff
,MAX((JULIANDAY(STRFTIME('%Y-%m-%d',order_delivered_customer_date)) - JULIANDAY(STRFTIME('%Y-%m-%d',order_purchase_timestamp)))) max_day_diff
,avg((JULIANDAY(STRFTIME('%Y-%m-%d',order_delivered_customer_date)) - JULIANDAY(STRFTIME('%Y-%m-%d',order_purchase_timestamp)))) avg_day_diff
from orders a
left join customers b on a.customer_id = b.customer_id 
group by b.customer_state 


-- BQ 4.3
WITH T1 AS (
select STRFTIME('%Y-%m',order_purchase_timestamp) as date_paid
,CASE WHEN order_estimated_delivery_date < order_delivered_customer_date THEN 'Late' ELSE 'on time' END AS Late_n
,COUNT(*) c_orders
from orders
group by date_paid,Late_n)
, T2 AS (
select date_paid,SUM(c_orders) total_order
from T1
group by date_paid)
select T1.date_paid,Late_n,ROUND((c_orders*1.0000/T2.total_order),3) ratio
from T1
join T2
on T1.date_paid = T2.date_paid 
where Late_n = 'Late'
order by ratio desc

-- BQ 4.4
select 
CASE WHEN a.order_estimated_delivery_date <= a.order_delivered_customer_date THEN 'Late' ELSE 'on Time' END AS delivery_Late
,AVG(b.review_score) avg_review
from orders a
left join order_reviews b 
on a.order_id = b.order_id
group by delivery_Late