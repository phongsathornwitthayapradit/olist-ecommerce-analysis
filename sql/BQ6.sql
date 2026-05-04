/*BQ6 — Review & Satisfaction

BQ6.1 Review score distribution โดยรวมเป็นอย่างไร?
BQ6.2 order ที่ได้ score 1-2 มี pattern อะไรร่วมกัน (late, freight สูง, หมวดไหน)?
BQ6.3 เวลาตอบกลับ review สัมพันธ์กับ score ไหม?*/

-- BQ 6.1
SELECT
    review_score,
    COUNT(*)                                           AS total_reviews,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM order_reviews
GROUP BY review_score
ORDER BY review_score DESC;

-- BQ 6.2 
select 
product_category_name_english
--,product_weight_g
,SUM(product_length_cm * product_height_cm * product_width_cm) cube_volumn
,SUM(b.freight_value) total_freight
,COUNT(d.review_score) c_score
,avg(d.review_score) avg_score
from orders a
left join order_items b on a.order_id = b.order_id 
left join (
select a.product_category_name_english ,b.*
from product_category_name_translation a
left join products b on a.product_category_name = b.product_category_name) c
on b.product_id = c.product_id 
left join order_reviews d on a.order_id = d.order_id 
where d.review_score in (1,2)
and product_category_name_english not null
--and product_category_name_english = 'watches_gifts'
group by product_category_name_english
order by c_score desc

-- BQ 6.3
WITH T1 AS (
    SELECT
        review_score,
        ROUND(JULIANDAY(review_answer_timestamp) -
              JULIANDAY(review_creation_date), 0) AS days_to_answer
    FROM order_reviews
    WHERE review_answer_timestamp IS NOT NULL
)
SELECT
    review_score,
    ROUND(AVG(days_to_answer), 2)   AS avg_days_to_answer,
    COUNT(*)                        AS total_reviews
FROM T1
GROUP BY review_score
ORDER BY review_score DESC;
