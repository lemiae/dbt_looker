-- stg_users: Tables retrieving data from a public BigQuery dataset (TheLook E-commerce)

-- Model structure:
-- 1. Cleaning and standardisation
-- 2. Useful calculations

{{ config(materialized='view') }}

select
    id as user_id,
    first_name,
    last_name,
    email,
    age,
    gender,
    state,
    street_address,
    postal_code,
    city,
    country,
    latitude,
    longitude,
    traffic_source,
    created_at,

    -- Cleaning and standardisation
    lower(trim(email)) as email_clean,
    case 
        when gender in ('M', 'Male') then 'Male'
        when gender in ('F', 'Female') then 'Female'
        else 'Other'
    end as gender_clean,
    case
        when age between 18 and 24 then '18-24'
        when age between 25 and 34 then '25-34'  
        when age between 35 and 44 then '35-44'
        when age between 45 and 54 then '45-54'
        when age between 55 and 64 then '55-64'
        when age >= 65 then '65+'
        else 'Unknown'
    end as age_group,
    
    -- Useful calculations
    date(created_at) as registration_date,
    extract(year from created_at) as registration_year,
    extract(month from created_at) as registration_month

from {{ source('dbt_looker_ecommerce', 'users') }}

where created_at is not null