view: fact_sales {
  sql_table_name: dbt_looker_project.dbt_looker_ecommerce.fact_sales ;;

  dimension: order_item_id {
    primary_key: yes
    type: string
    sql: ${TABLE}.order_item_id ;;
    }

  dimension: order_id {
    type: string
    sql: ${TABLE}.order_id ;;
    }

  dimension: user_id {
    type: string
    sql: ${TABLE}.user_id ;;
    }

  dimension: product_id {
    type: string
    sql: ${TABLE}.product_id ;;
    }

  dimension_group: order_date {
    type: time
    timeframes: [raw, date, week, month, quarter, year]
    sql: ${TABLE}.order_item_date ;;
    }

  dimension: age_group {
    type: string
    sql: ${TABLE}.age_group ;;
    }

  dimension: customer_gender {
    type: string
    sql: ${TABLE}.customer_gender ;;
    }

  dimension: customer_state {
    type: string
    sql: ${TABLE}.customer_state ;;
    }

  dimension: customer_country {
    type: string
    sql: ${TABLE}.customer_country ;;
    }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
    }

  dimension: customer_segment {
    type: string
    sql: ${TABLE}.customer_segment ;;
    }

  dimension: recency_status {
    type: string
    sql: ${TABLE}.recency_status ;;
    }

  dimension: product_category {
    type: string
    sql: ${TABLE}.product_category ;;
    }

  dimension: product_brand {
    type: string
    sql: ${TABLE}.product_brand ;;
    }

  dimension: product_department {
    type: string
    sql: ${TABLE}.product_department ;;
    }

  dimension: price_segment {
    type: string
    sql: ${TABLE}.price_segment ;;
    }

  dimension: order_status {
    type: string
    sql: ${TABLE}.order_status ;;
    }

  dimension: items_in_order {
    type: number
    sql: ${TABLE}.items_in_order ;;
    }

  dimension: days_to_ship {
    type: number
    sql: ${TABLE}.days_to_ship ;;
    }

  dimension: days_to_deliver {
    type: number
    sql: ${TABLE}.days_to_deliver ;;
    }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
    }

  dimension: product_cost {
    type: number
    sql: ${TABLE}.product_cost ;;
    }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
    }

  dimension: discount_amount {
    type: number
    sql: ${TABLE}.discount_amount ;;
    }

  dimension: is_cancelled {
    type: yesno
    sql: ${TABLE}.is_cancelled ;;
    }

  dimension: is_delivered {
    type: yesno
    sql: ${TABLE}.is_delivered ;;
    }

  dimension: order_is_cancelled {
    type: yesno
    sql: ${TABLE}.order_is_cancelled ;;
    }

  dimension: is_discounted {
    type: yesno
    sql: ${TABLE}.is_discounted ;;
    }

  dimension: is_profitable {
    type: yesno
    sql: ${TABLE}.is_profitable ;;
    }

  dimension: season {
    type: string
    sql: ${TABLE}.season ;;
    }
}
