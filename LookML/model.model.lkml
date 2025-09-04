connection: "bigquery_connection"  # nam of the connection
include: "*.view"

explore: fact_sales {
  label: "Analyse des ventes"

  # Join with product_id
  join: dim_products {
    type: left_outer
    sql_on: ${fact_sales.product_id} = ${dim_products.product_id} ;;
    relationship: many_to_one
  }

  # Join with user_id
  join: dim_users {
    type: left_outer
    sql_on: ${fact_sales.user_id} = ${dim_users.user_id} ;;
    relationship: many_to_one
  }
}