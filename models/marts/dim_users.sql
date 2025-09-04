
--  Customer Dimension (dim_users): Final table
  
--  This table centralises all customer information with their behavioural and financial metrics.
--  Behavioural and financial metrics.
  
-- Model structure:
-- 1. Keys and basic information
-- 2. Behavioural metrics
-- 3. Financial metrics
-- 4. Segmentations for analysis and marketing
-- 5. Boolean flags useful for analysis and creating visualisations
-- 6. Calculated metrics for analysis
-- 7. Customer score

{{ config(materialized='table') }}

select
    -- Keys and basic information
    user_id,
    first_name,
    last_name,
    email_clean,
    age_group,
    gender_clean,
    state,
    country,
    traffic_source,
    registration_date,
    
    -- Behavioural metrics
    total_orders,
    completed_orders,
    first_order_date,
    last_order_date,
    days_since_last_order,
    
    -- Financial metrics
    total_revenue,
    avg_order_value,
    total_items_purchased,
    
    -- Segmentations for analysis and marketing
    customer_segment,  -- VIP, Loyal, Regular, One-time, Prospect
    recency_status,    -- Active, At Risk, Inactive, Lost
    
    -- Boolean flags useful for analysis and creating visualisations
    case when total_orders > 1 then true else false end as is_repeat_customer,
    case when days_since_last_order <= 30 then true else false end as is_active_customer,
    case when total_revenue >= 500 then true else false end as is_high_value,
    
    -- Calculated metrics for analysis
    case 
        when total_orders > 0 
        then round(total_revenue / total_orders, 2)
        else 0 
    end as actual_avg_order_value,
    
    -- Composite customer score (0-100) to prioritise actions
    least(100, 
        -- Points by segment (40 max)
        case when customer_segment = 'VIP' then 40
             when customer_segment = 'Loyal' then 30
             when customer_segment = 'Regular' then 20
             when customer_segment = 'One-time' then 10
             else 0 end +
        -- Points based on recency (40 max)
        case when recency_status = 'Active' then 40
             when recency_status = 'At Risk' then 30
             when recency_status = 'Inactive' then 20
             else 0 end +
        -- Points based on basket value (max. 20)
        case when avg_order_value >= 100 then 20
             when avg_order_value >= 50 then 15
             when avg_order_value >= 25 then 10
             else 5 end
    ) as customer_score

from {{ ref('int_user_orders') }}
where user_id is not null