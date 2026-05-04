/*BQ2 — Customer Analysis

BQ2.1 มีลูกค้าทั้งหมดกี่คน และกี่ % ที่กลับมาซื้อซ้ำ?
BQ2.2 รัฐไหนมียอดสั่งซื้อและ revenue สูงที่สุด Top 10?
BQ2.3 ลูกค้าที่ซื้อซ้ำมักซื้อห่างกันกี่วันโดยเฉลี่ย?
BQ2.4 รัฐไหนมี avg_order_value สูงที่สุด สะท้อนกำลังซื้อ?
 * */

-- BQ 2.1
WITH T1 as (
select 
b.customer_unique_id ,count(*) as c_rows
from orders a 
left join (select distinct customer_id,customer_unique_id from customers) b 
on a.customer_id = b.customer_id
group by b.customer_unique_id)
, T2 AS (
select *,
case when c_rows > 1 THEN 'customer_return' Else 'customer_Once' END AS Type_customer
from T1)
SELECT
    Type_customer,
    COUNT(*)                                           AS total_customers,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS ratio
FROM T2
GROUP BY Type_customer;

-- BQ 2.2, BQ 2.4
WITH T_state AS (
select distinct customer_id,customer_state from customers)
, T_order AS (
select a.customer_id
,SUM(b.price) total_price
from orders a
left join order_items b on a.order_id = b.order_id 
group by a.customer_id)
select a.customer_state ,count(*) c_rows,SUM(b.total_price) total_price,ROUND(AVG(b.total_price),2) avg_order_item
from T_state a
left join T_order b 
on a.customer_id = b.customer_id 
group by a.customer_state 
order by total_price desc

WITH T_state AS (
    SELECT customer_id, customer_state FROM customers
),
T_order AS (
    SELECT
        a.customer_id,
        COUNT(DISTINCT a.order_id)  AS total_orders,
        ROUND(SUM(b.price), 2)      AS total_price
    FROM orders a
    JOIN order_items b ON a.order_id = b.order_id
--    WHERE a.order_status = 'delivered'
    GROUP BY a.customer_id
)
SELECT
    a.customer_state,
    COUNT(*)                                        AS total_customers,
    SUM(b.total_orders)                             AS total_orders,
    ROUND(SUM(b.total_price), 2)                    AS total_revenue,
    ROUND(SUM(b.total_price) / SUM(b.total_orders), 2) AS avg_order_value 
FROM T_state a
JOIN T_order b ON a.customer_id = b.customer_id
GROUP BY a.customer_state
ORDER BY total_revenue DESC
LIMIT 10;

-- BQ 2.3
WITH customer_orders AS (
    SELECT
        c.customer_unique_id,
        o.order_purchase_timestamp,
        LAG(o.order_purchase_timestamp) OVER (
            PARTITION BY c.customer_unique_id
            ORDER BY o.order_purchase_timestamp
        ) AS prev_order_date
    FROM orders o
    JOIN customers c ON o.customer_id = c.customer_id
    WHERE o.order_status = 'delivered'
)
SELECT
    ROUND(AVG(
        JULIANDAY(order_purchase_timestamp) -
        JULIANDAY(prev_order_date)
    ), 1) AS avg_days_between_orders,
    COUNT(*) AS repeat_order_count
FROM customer_orders
WHERE prev_order_date IS NOT NULL;