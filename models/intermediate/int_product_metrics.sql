--  Intermediate model (int_product_metrics): Product performance aggregation
  
--  Model structure:
--  1. Basic product information
--  2. Volumes and turnover
--  3. Product activity dates  
--  4. Profitability calculations
--  5. Activity status based on last order for sales


{{ config(materialized='view') }}

select
    -- Basic product information
    p.product_id,
    p.product_name,
    p.category_clean,
    p.brand_clean,
    p.department_clean,
    p.cost_clean,
    p.retail_price_clean,
    p.profit_margin,
    p.profit_margin_pct,
    p.price_segment,
    
    -- Volumes and turnover
    count(oi.order_item_id) as total_units_sold,
    count(distinct oi.order_id) as total_orders,
    count(distinct oi.user_id) as unique_customers,
    sum(oi.sale_price_clean) as total_revenue,
    round(avg(oi.sale_price_clean), 2) as avg_selling_price,
    
    -- Product activity dates 
    min(oi.order_item_date) as first_sale_date,
    max(oi.order_item_date) as last_sale_date,
    date_diff(current_date(), max(oi.order_item_date), day) as days_since_last_sale,
    
    -- Profitability calculations
    sum(oi.sale_price_clean - p.cost_clean) as total_profit,
    
    -- Activity status based on last order for sales
    case 
        when date_diff(current_date(), max(oi.order_item_date), day) <= 30 then 'Active'
        when date_diff(current_date(), max(oi.order_item_date), day) <= 90 then 'Declining'
        when date_diff(current_date(), max(oi.order_item_date), day) <= 180 then 'Inactive'
        else 'Discontinued'
    end as activity_status

from {{ ref('stg_products') }} p
left join {{ ref('stg_order_items') }} oi on p.product_id = oi.product_id
where oi.status_clean = 'Completed' or oi.status_clean is null
group by p.product_id, p.product_name, p.category_clean, p.brand_clean, p.department_clean,
         p.cost_clean, p.retail_price_clean, p.profit_margin, p.profit_margin_pct, p.price_segment