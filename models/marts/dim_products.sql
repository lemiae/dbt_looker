
--  Product Dimension (dim_products): Final table
  
--  This table centralises all product information with their behavioural and financial metrics.
--  Structure of the model:
  
--  Model structure:
--  1. Prices and costs
--  2. Sales metrics
--  3. Dates
--  4. Calculated metrics
--  5. Classifications
--  6. Flags for analysis

{{ config(materialized='table') }}

select
    product_id,
    product_name,
    category_clean as category,
    brand_clean as brand,
    department_clean as department,

    -- Prices and costs
    cost_clean as cost,
    retail_price_clean as retail_price,
    profit_margin,
    profit_margin_pct,
    price_segment,

    -- Sales metrics
    coalesce(total_units_sold, 0) as total_units_sold,
    coalesce(total_orders, 0) as total_orders,
    coalesce(unique_customers, 0) as unique_customers,
    coalesce(total_revenue, 0) as total_revenue,
    coalesce(avg_selling_price, retail_price_clean) as avg_selling_price,

    -- Dates
    first_sale_date,
    last_sale_date,
    days_since_last_sale,

    -- Calculated metrics
    coalesce(total_profit, 0) as total_profit,

    -- Classifications
    coalesce(activity_status, 'Never Sold') as activity_status,

    -- Flags for analysis
    case when total_units_sold > 0 then true else false end as has_sales,
    case when last_sale_date >= date_sub(current_date(), interval 30 day) then true else false end as sold_recently,
    case when total_profit > 0 then true else false end as is_profitable,


from {{ ref('int_product_metrics') }}

where product_id is not null