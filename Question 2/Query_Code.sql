--- Create Tables: brands, receipt_items, receipts, users 

CREATE TABLE IF NOT EXISTS public.users
(
    created_date date,
    birth_date date,
    gender character varying,
    last_rewards_login date,
    state character varying,
    sign_up_platform character varying,
    sign_up_source character varying,
    id character varying 
); 

CREATE TABLE IF NOT EXISTS public.receipts
(
    id varchar,
    store_name varchar,
    purchase_date date,
    purchase_time time,
	date_scanned date,
	total_spent numeric,
	rewards_receipt_status varchar,
	user_id varchar,
	user_viewed varchar,
	purchased_item_count int,
	create_date date,
	pending_date date,
	modify_date date,
	flagged_date date,
	processed_date date,
	finished_date date,
	rejected_date date,
	needs_fetch_review varchar,
	digital_receipt varchar,
	deleted varchar,
	non_point_earning_receipt varchar
);


CREATE TABLE IF NOT EXISTS public.brands
(
    id varchar,
    barcode varchar,
    brandcode varchar,
    CPG_ID varchar,
	category varchar,
	category_code varchar,
	name varchar, 
	romance_text varchar, 
	related_brand_ids varchar
);

CREATE TABLE IF NOT EXISTS public.receipt_items
(
    rewards_receipt_id varchar,
    item_index int,
    rewards_receipt_item_id varchar,
    description varchar,
	barcode varchar,
	brandcode varchar,
	quantity_purchased double precision,
	total_final_price numeric,
	points_rewarded numeric,
	rewards_group varchar,
	original_receipt_item_text varchar,
	modify_date date
);


--- Question 2: which user spent the most money in the month of Auguest? 
SELECT user_id,
       EXTRACT(month FROM purchase_date) AS month,
	   SUM(total_spent) AS total_spent
FROM receipts 
WHERE EXTRACT(month FROM purchase_date) = 8
GROUP BY user_id, month
ORDER BY total_spent DESC
LIMIT 1
---user_id = "609ab37f7a2e8f2f95ae968f" spent the most money in the month of Auguest

---Question 3: which user bought the most expensive item 
SELECT ri.total_final_price/ri.quantity_purchased AS unit_price, 
	   r.user_id
FROM receipt_items ri
LEFT JOIN receipts r
ON ri.rewards_receipt_id = r.id
WHERE quantity_purchased >0 AND total_final_price>0
ORDER BY unit_price DESC
LIMIT 1
--- user_id: 617376b8a9619d488190e0b6 bought the most expensive item

--- Question 4: what's the name of the most expensive item purchased 
SELECT r.total_final_price/r.quantity_purchased AS unit_price, 
       r.brandcode, b.name
FROM receipt_items r
LEFT JOIN brands b
USING (brandcode)
WHERE quantity_purchased >0 AND total_final_price>0
ORDER BY unit_price DESC
LIMIT 1
--- startbucks is the name of the most expensive item purchased 

--- Question 5: How many users scanned in each month 
SELECT EXTRACT(month FROM date_scanned) AS month,
       COUNT(DISTINCT user_id)
FROM receipts 
GROUP BY month 
ORDER BY month







