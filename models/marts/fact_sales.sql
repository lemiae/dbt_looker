-- Order Items Fact Table (fact_order_items): Final table

-- This table centralises all order item transactions with enriched customer, product, 
-- and order information for comprehensive sales and business analysis.

-- Model structure:
-- 1. Keys and identifiers
-- 2. Temporal informations
-- 3. Customer informations
-- 4. Product informations
-- 5. Order informations
-- 6. Financial metrics
-- 7. Flags
-- 8. Seasonality flags

{{ config(materialized='table') }}

select
    -- Keys and identifiers
    oi.order_item_id,
    oi.order_id,
    oi.user_id,
    oi.product_id,

    -- Temporal informations
    oi.order_item_date,
    -- Looker can easily create these fields with dimension_groups
    --oi.order_item_year,
    --oi.order_item_month,
    --extract(dayofweek from oi.order_item_date) as day_of_week,
    --format_date( '%A', oi.order_item_date) as day_name,
    --extract(week from oi.order_item_date) as week_of_year,

    -- Customer informations
    u.age_group,
    u.gender_clean as customer_gender,
    u.state as customer_state,
    u.country as customer_country,
    u.traffic_source,
    u.customer_segment,
    u.recency_status,

    -- Product informations
    p.category as product_category,
    p.brand as product_brand,
    p.department as product_department,
    p.price_segment,

    -- Order informations
    o.status_clean as order_status,
    o.num_of_item as items_in_order,
    o.days_to_ship,
    o.days_to_deliver,

    -- Financial metrics
    oi.sale_price_clean as sale_price,
    p.cost as product_cost,
    p.retail_price as retail_price,

    -- Écart par rapport au prix de détail
    oi.sale_price_clean - p.retail_price as discount_amount,

    -- Flags
    oi.is_cancelled,
    oi.is_delivered,
    o.is_cancelled as order_is_cancelled,
    case when oi.sale_price_clean < p.retail_price then true else false end as is_discounted,
    case when oi.sale_price_clean - p.cost > 0 then true else false end as is_profitable,

    -- Seasonality flags
    case 
        when extract(month from oi.order_item_date) in (12, 1, 2) then 'Winter'
        when extract(month from oi.order_item_date) in (3, 4, 5) then 'Spring'
        when extract(month from oi.order_item_date) in (6, 7, 8) then 'Summer'
        when extract(month from oi.order_item_date) in (9, 10, 11) then 'Fall'
        else 'Unknown'
    end as season,

from {{ ref('stg_order_items') }} oi
left join {{ ref('dim_users') }} u on oi.user_id = u.user_id
left join {{ ref('dim_products') }} p on oi.product_id = p.product_id
left join {{ ref('stg_orders') }} o on oi.order_id = o.order_id

where oi.status_clean = 'Completed'
  and oi.sale_price_clean > 0