-- stg_products: Tables retrieving data from a public BigQuery dataset (TheLook E-commerce)

-- Model structure:
-- 1. Cleaning and standardisation
-- 2. Financial calculations
-- 3. Price categorisation

-- Future improvements: addition of currency, conversion rates

{{ config(materialized='view') }}

select
    id as product_id,
    cost,
    category,
    name as product_name,
    brand,
    retail_price,
    department,
    sku,
    distribution_center_id,

    -- Cleaning and standardisation
    trim(upper(category)) as category_clean,
    trim(initcap(brand)) as brand_clean,
    trim(initcap(department)) as department_clean,
    trim(upper(sku)) as sku_clean,

    -- Financial calculations
    round(cost, 2) as cost_clean,
    round(retail_price, 2) as retail_price_clean,
    round(retail_price - cost, 2) as profit_margin,
    round((retail_price - cost) / nullif(retail_price, 0) * 100, 2) as profit_margin_pct,

    -- Price categorisation
    case 
        when retail_price > 200 then 'Premium'
        when retail_price > 100 then 'High'
        when retail_price > 50 then 'Medium'
        else 'Budget'
    end as price_segment

from {{ source('dbt_looker_ecommerce', 'products') }}

where cost > 0 
  and retail_price > 0