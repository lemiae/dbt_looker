
--  Intermediate model (int_user_orders): Aggregation of customer metrics
  
--  This model combines user data with their purchasing behaviour
--  in order to create useful metrics for customer segmentation.
  
--  Model structure:
--  1. Basic customer information
--  2. Order metrics: count orders by status
--  3. Important dates for analysing behaviour
--  4. Turnover and average basket size per customer
--  5. Automatic customer segmentation
--  6. Customer status


{{ config(materialized='view') }}

select
    -- Basic customer information
    u.user_id,
    u.first_name,
    u.last_name,
    u.email_clean,
    u.age_group,
    u.gender_clean,
    u.state,
    u.country,
    u.traffic_source,
    u.registration_date,
    
    -- Order metrics: count orders by status
    count(distinct o.order_id) as total_orders,
    count(distinct case when o.status_clean = 'Completed' then o.order_id end) as completed_orders,
    
    -- Important dates for analysing behaviour
    min(o.order_date) as first_order_date,
    max(o.order_date) as last_order_date,
    date_diff(current_date(), max(o.order_date), day) as days_since_last_order,
    
    -- Turnover and average basket size per customer
    sum(oi.sale_price_clean) as total_revenue,
    round(avg(oi.sale_price_clean), 2) as avg_order_value,
    count(oi.order_item_id) as total_items_purchased,
    
    -- Automatic customer segmentation
    case 
        when count(distinct o.order_id) >= 10 and sum(oi.sale_price_clean) >= 500 then 'VIP'
        when count(distinct o.order_id) >= 5 and sum(oi.sale_price_clean) >= 200 then 'Loyal'
        when count(distinct o.order_id) >= 2 then 'Regular'
        when count(distinct o.order_id) = 1 then 'One-time'
        else 'Prospect'
    end as customer_segment,
    
    -- Customer status (active, inactive, etc.) based on their last order
    case 
        when date_diff(current_date(), max(o.order_date), day) <= 30 then 'Active'
        when date_diff(current_date(), max(o.order_date), day) <= 90 then 'At Risk'
        when date_diff(current_date(), max(o.order_date), day) <= 180 then 'Inactive'
        else 'Lost'
    end as recency_status

from {{ ref('stg_users') }} u
left join {{ ref('stg_orders') }} o on u.user_id = o.user_id
left join {{ ref('stg_order_items') }} oi on o.order_id = oi.order_id
where oi.status_clean = 'Completed' or oi.status_clean is null
group by u.user_id, u.first_name, u.last_name, u.email_clean, u.age_group, 
         u.gender_clean, u.state, u.country, u.traffic_source, u.registration_date