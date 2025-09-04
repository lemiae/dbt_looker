view: dim_products {
  sql_table_name: dbt_looker_project.dbt_looker_ecommerce.dim_products ;;

  dimension: product_id { 
    primary_key: yes
    type: string 
    sql: ${TABLE}.product_id ;; 
    }

  dimension: product_name { 
    type: string 
    sql: ${TABLE}.product_name ;; 
    }

  dimension: category { 
    type: string 
    sql: ${TABLE}.category ;; 
    }

  dimension: brand { 
    type: string 
    sql: ${TABLE}.brand ;; 
    }

  dimension: department { 
    type: string 
    sql: ${TABLE}.department ;; 
    }

  dimension: price_segment { 
    type: string 
    sql: ${TABLE}.price_segment ;; 
    }

  dimension: cost { 
    type: number 
    sql: ${TABLE}.cost ;; 
    value_format: "#,##0.00 €" 
    }

  dimension: retail_price { 
    type: number 
    sql: ${TABLE}.retail_price ;; 
    value_format: "#,##0.00 €" 
    }

  dimension: profit_margin { 
    type: number 
    sql: ${TABLE}.profit_margin ;; 
    value_format: "#,##0.00 €" 
    }

  dimension: profit_margin_pct { 
    type: number 
    sql: ${TABLE}.profit_margin_pct ;; 
    value_format: "0.0%" 
    }

  measure: total_units_sold { 
    type: sum 
    sql: ${TABLE}.total_units_sold ;; 
    }

  measure: total_orders { 
    type: sum 
    sql: ${TABLE}.total_orders ;; 
    }

  measure: unique_customers { 
    type: sum 
    sql: ${TABLE}.unique_customers ;; 
    }

  measure: total_revenue { 
    type: sum 
    sql: ${TABLE}.total_revenue ;; 
    value_format: "#,##0.00 €" 
    }

  measure: avg_selling_price { 
    type: average 
    sql: ${TABLE}.avg_selling_price ;; 
    value_format: "#,##0.00 €" 
    }

  measure: total_profit { 
    type: sum 
    sql: ${TABLE}.total_profit ;; 
    value_format: "#,##0.00 €" 
    }

  dimension_group: first_sale_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.first_sale_date ;;
    }

  dimension_group: last_sale_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.last_sale_date ;;
    }

  measure: days_since_last_sale { 
    type: average 
    sql: ${TABLE}.days_since_last_sale ;; 
    }

  dimension: activity_status { 
    type: string 
    sql: ${TABLE}.activity_status ;; 
    }

  dimension: has_sales { 
    type: yesno 
    sql: ${TABLE}.has_sales ;; 
    }

  dimension: sold_recently { 
    type: yesno 
    sql: ${TABLE}.sold_recently ;; 
    }

  dimension: is_profitable { 
    type: yesno 
    sql: ${TABLE}.is_profitable ;; 
    }
}
