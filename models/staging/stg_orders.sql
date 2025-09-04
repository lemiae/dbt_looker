-- stg_orders: Tables retrieving data from a public BigQuery dataset (TheLook E-commerce)

-- Model structure:
-- 1. Status cleaning
-- 2. Calculation of useful dates
-- 3. Calculation of deadlines
-- 4. Flags

{{ config(materialized='view') }}

select
    order_id,
    user_id,
    status,
    gender,
    created_at,
    returned_at,
    shipped_at,
    delivered_at,
    num_of_item,

    -- Status cleaning
    case 
        when lower(status) = 'complete' then 'Completed'
        when lower(status) = 'shipped' then 'Shipped'
        when lower(status) = 'processing' then 'Processing'
        when lower(status) = 'cancelled' then 'Cancelled'
        when lower(status) = 'returned' then 'Returned'
        else initcap(status)
    end as status_clean,

    -- Calculation of useful dates
    date(created_at) as order_date,
    extract(year from created_at) as order_year,
    extract(month from created_at) as order_month,
    extract(dayofweek from created_at) as order_day_of_week,
    format_date('%A', date(created_at)) as order_day_name,
    
    -- Calculation of deadlines (in days)
    case 
        when shipped_at is not null 
        then date_diff(date(shipped_at), date(created_at), day)
        else null 
    end as days_to_ship,
    case 
        when delivered_at is not null 
        then date_diff(date(delivered_at), date(created_at), day)
        else null 
    end as days_to_deliver,

    -- Flags booléens
    case when status in ('Cancelled', 'cancelled') then true else false end as is_cancelled

from {{ source('dbt_looker_ecommerce', 'orders') }}

where created_at is not null