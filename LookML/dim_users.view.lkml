view: dim_users {
  sql_table_name: dbt_looker_project.dbt_looker_ecommerce.dim_users ;;

  dimension: user_id { 
    primary_key: yes
    type: string 
    sql: ${TABLE}.user_id ;; 
    }

  dimension: first_name { 
    type: string 
    sql: ${TABLE}.first_name ;; 
    }

  dimension: last_name { 
    type: string 
    sql: ${TABLE}.last_name ;; 
    }

  dimension: email_clean { 
    type: string 
    sql: ${TABLE}.email_clean ;; 
    }

  dimension: age_group { 
    type: string 
    sql: ${TABLE}.age_group ;; 
    }

  dimension: gender_clean { 
    type: string 
    sql: ${TABLE}.gender_clean ;; 
    }

  dimension: state { 
    type: string 
    sql: ${TABLE}.state ;; 
    }

  dimension: country { 
    type: string  
    sql: ${TABLE}.country ;; 
    }

  dimension: traffic_source { 
    type: string 
    sql: ${TABLE}.traffic_source ;; 
    }

  dimension_group: registration_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.registration_date ;;
    }

  measure: total_orders { 
    type: sum 
    sql: ${TABLE}.total_orders ;; 
    }

  measure: completed_orders { 
    type: sum 
    sql: ${TABLE}.completed_orders ;; 
    }

  dimension_group: first_order_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.first_order_date ;;
    }

  dimension_group: last_order_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.last_order_date ;;
    }

  measure: days_since_last_order { 
    type: average 
    sql: ${TABLE}.days_since_last_order ;; 
    }

  measure: total_revenue { 
    type: sum 
    sql: ${TABLE}.total_revenue ;; 
    value_format: "#,##0.00 €" 
    }

  measure: avg_order_value { 
    type: average 
    sql: ${TABLE}.avg_order_value ;; 
    value_format: "#,##0.00 €" 
    }

  measure: total_items_purchased { 
    type: sum 
    sql: ${TABLE}.total_items_purchased ;; 
    }

  measure: actual_avg_order_value { 
    type: average 
    sql: ${TABLE}.actual_avg_order_value ;; 
    value_format: "#,##0.00 €" 
    }

  dimension: customer_segment { 
    type: string 
    sql: ${TABLE}.customer_segment ;; 
    }

  dimension: recency_status { 
    type: string 
    sql: ${TABLE}.recency_status ;; 
    }

  dimension: is_repeat_customer { 
    type: yesno
    sql: ${TABLE}.is_repeat_customer ;; 
    }

  dimension: is_active_customer { 
    type: yesno 
    sql: ${TABLE}.is_active_customer ;; 
    }

  dimension: is_high_value { 
    type: yesno 
    sql: ${TABLE}.is_high_value ;; 
    }

  measure: customer_score { 
    type: average 
    sql: ${TABLE}.customer_score ;; 
    }
}
