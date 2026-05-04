/*
BQ1 — Sales Overview
BQ1.1 ยอดขายรวม (Total Revenue, Total Orders, Avg Order Value) ทั้งหมดเป็นเท่าไหร่?
BQ1.2 ยอดขายรายเดือนเป็นอย่างไร มีช่วงไหนพุ่งหรือดิ่งผิดปกติไหม?
BQ1.3 สัดส่วน Order Status (delivered, cancelled, etc.) เป็นอย่างไร?
BQ1.4 Payment Type ไหนได้รับความนิยมสูงสุด และมี avg installment เท่าไหร่?
 * */

-- BQ1.1,BQ1.2
SELECT 
b.product_category_name_english as prod_n ,c.order_status
,c.purch_date,c.deli_date ,c.appr_date ,c.delic_date ,c.esti_date 
,SUM(a.price + a.freight_value) total_amount
,count(a.order_item_id) count_item
,AVG(a.price + a.freight_value) avg_amount
FROM order_items a 
left join (
select distinct a1.product_id ,b1.product_category_name_english 
from products a1 
left join product_category_name_translation b1
on a1.product_category_name = b1.product_category_name) b
on a.product_id = b.product_id 
-- BQ 1.2
left join (
select  order_id,order_status
,STRFTIME('%Y-%m',order_purchase_timestamp) purch_date
,STRFTIME('%Y-%m',order_approved_at) appr_date
,STRFTIME('%Y-%m',order_delivered_carrier_date) deli_date
,STRFTIME('%Y-%m',order_delivered_customer_date) delic_date
,STRFTIME('%Y-%m',order_estimated_delivery_date) esti_date
from orders) c 
on a.order_id = c.order_id 
where prod_n is not null
group by b.product_category_name_english
,c.purch_date,c.deli_date ,c.appr_date ,c.delic_date ,c.esti_date 
-- ทำสรุปยอดขาย แบ่งตามเดือนและประเภท
/*จาก Query จะได้ข้อมูลที่น่าสนใจ
 * 1. ยอดซื้อ ณ 2017-11 เพิ่มขึ้นสูงมากและสินค้าที่ขายเยอะ Top 3 คือ
1. bed_bath_table
2. watches_gifts
3. health_beauty
 * 2.ยอดการยกเลิกเพิ่มขึ้นสูงในเดือน 2018-07
*/

-- BQ1.1 ยอดขายรวมทั้งหมด
SELECT
    COUNT(DISTINCT o.order_id)              AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2) AS total_revenue,
    ROUND(AVG(oi.price + oi.freight_value), 2) AS avg_order_value
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered';

-- BQ1.2 ยอดขายรายเดือน
SELECT
    STRFTIME('%Y-%m', o.order_purchase_timestamp) AS month,
    COUNT(DISTINCT o.order_id)                     AS total_orders,
    ROUND(SUM(oi.price + oi.freight_value), 2)     AS total_revenue
    ,(ROUND(SUM(oi.price + oi.freight_value), 2) - LAG(ROUND(SUM(oi.price + oi.freight_value), 2)) OVER(ORDER BY STRFTIME('%Y-%m', o.order_purchase_timestamp)))/LAG(ROUND(SUM(oi.price + oi.freight_value), 2)) OVER(ORDER BY STRFTIME('%Y-%m', o.order_purchase_timestamp)) as t1
FROM orders o
JOIN order_items oi ON o.order_id = oi.order_id
WHERE o.order_status = 'delivered'
GROUP BY month
ORDER BY month;

-- BQ 1.3
SELECT
    order_status,
    COUNT(*)                                           AS total_orders,
    ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

-- BQ 1.4
select op.payment_type
,AVG(payment_installments) avg_payment_installments
,AVG(op.payment_value ) avg_values
from order_payments op 
GROUP by payment_type;