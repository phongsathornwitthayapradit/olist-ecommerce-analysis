/*BQ5 — Seller Performance

BQ5.1 Top 20 sellers by revenue พร้อม satisfaction rank เป็นอย่างไร?
BQ5.2 seller ที่ส่งเร็วกับช้า review score ต่างกันมากไหม?
BQ5.3 รัฐไหนมี seller เยอะที่สุด และ performance เป็นอย่างไร?*/

-- BQ 5.1 
WITH seller_stats AS (
    SELECT
        a.seller_id,
        b.seller_state,
        COUNT(DISTINCT a.order_id)     AS total_orders,
        ROUND(SUM(a.price), 2)         AS total_revenue,
        ROUND(AVG(r.review_score), 2)  AS avg_review_score
    FROM order_items a
    JOIN sellers b       ON a.seller_id = b.seller_id
    JOIN order_reviews r ON a.order_id = r.order_id
    GROUP BY a.seller_id, b.seller_state
)
SELECT *,
    RANK() OVER (ORDER BY total_revenue DESC)      AS revenue_rank,
    RANK() OVER (ORDER BY avg_review_score DESC)   AS satisfaction_rank
FROM seller_stats
ORDER BY satisfaction_rank
LIMIT 20;

-- BQ 5.2
select a.seller_id 
,COUNT(*) c_orders
,MIN(b.review_score) min_score
,AVG(b.review_score) avg_score
,MAX(b.review_score) max_score
from order_items a
left join order_reviews b on a.order_id = b.order_id 
group by a.seller_id 
order by c_orders desc

WITH seller_delivery AS (
    SELECT
        oi.seller_id,
        AVG(JULIANDAY(o.order_delivered_customer_date) -
            JULIANDAY(o.order_purchase_timestamp))  AS avg_delivery_days,
        AVG(r.review_score)                         AS avg_review_score,
        COUNT(DISTINCT oi.order_id)                 AS total_orders
    FROM order_items oi
    JOIN orders o        ON oi.order_id = o.order_id
    JOIN order_reviews r ON oi.order_id = r.order_id
    WHERE o.order_status = 'delivered'
      AND o.order_delivered_customer_date IS NOT NULL
    GROUP BY oi.seller_id
    HAVING total_orders >= 10  -- กรอง seller ที่มีข้อมูลพอ
)
SELECT
    CASE
        WHEN avg_delivery_days <= 7  THEN 'Fast'
        WHEN avg_delivery_days <= 14 THEN 'Normal'
        ELSE 'Slow'
    END                             AS delivery_group,
    COUNT(*)                        AS total_sellers,
    ROUND(AVG(avg_delivery_days), 1) AS avg_days,
    ROUND(AVG(avg_review_score), 2)  AS avg_review_score
FROM seller_delivery
GROUP BY delivery_group
ORDER BY avg_days;

-- BQ 5.3
SELECT
    b.seller_state,
    COUNT(DISTINCT b.seller_id)             AS total_sellers,
    COUNT(DISTINCT a.order_id)              AS total_orders,
    ROUND(SUM(a.price), 2)                  AS total_revenue,
    ROUND(AVG(r.review_score), 2)           AS avg_review_score,
    ROUND(AVG(
        JULIANDAY(o.order_delivered_customer_date) -
        JULIANDAY(o.order_purchase_timestamp)
    ), 1)                                   AS avg_delivery_days
FROM order_items a
JOIN sellers b       ON a.seller_id = b.seller_id
JOIN orders o        ON a.order_id = o.order_id
JOIN order_reviews r ON a.order_id = r.order_id
WHERE o.order_status = 'delivered'
GROUP BY b.seller_state
ORDER BY total_revenue DESC;