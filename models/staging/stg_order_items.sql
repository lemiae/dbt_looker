-- stg_order_items: Tables retrieving data from a public BigQuery dataset (TheLook E-commerce)

-- Model structure:
-- 1. Data cleaning
-- 2. Financial calculations
-- 3. Useful dates
-- 4. Flags

{{ config(materialized='view') }}

select
    id as order_item_id,
    order_id,
    user_id,
    product_id,
    inventory_item_id,
    status,
    created_at,
    shipped_at,
    delivered_at,
    returned_at,
    sale_price,

    -- Data cleaning
    case 
        when lower(status) = 'complete' then 'Completed'
        when lower(status) = 'shipped' then 'Shipped'
        when lower(status) = 'processing' then 'Processing'
        when lower(status) = 'cancelled' then 'Cancelled'
        when lower(status) = 'returned' then 'Returned'
        else initcap(status)
    end as status_clean,

    -- Financial calculations
    round(sale_price, 2) as sale_price_clean,
    case 
        when sale_price > 100 then 'High Value'
        when sale_price > 50 then 'Medium Value'
        else 'Low Value'
    end as price_tier,

    -- Useful dates
    date(created_at) as order_item_date,
    extract(year from created_at) as order_item_year,
    extract(month from created_at) as order_item_month,

    -- Flags
    case when returned_at is not null then true else false end as is_returned,
    case when status = 'Cancelled' then true else false end as is_cancelled,
    case when delivered_at is not null then true else false end as is_delivered

from {{ source('dbt_looker_ecommerce', 'order_items') }}

where created_at is not null
  and sale_price > 0