view: order_items {
  sql_table_name: public.order_items ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension_group: delivered {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.delivered_at ;;
  }

  dimension: inventory_item_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension_group: returned {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    sql: ${TABLE}.sale_price ;;
  }

  dimension_group: shipped {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.shipped_at ;;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: is_returned {
    type: yesno
    sql: ${returned_raw} is not null ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  measure: total_sales_price {
    type: sum
    sql: ${sale_price} ;;
  }

  measure: average_sales_price {
    type: average
    sql: ${sale_price} ;;
  }

  measure: first_order {
    type: time
    sql: min(${created_date}) ;;
  }

  measure: last_order {
    type: time
    sql: max(${created_date}) ;;
  }

  measure: returned_count {
    type: count
    filters: {
      field: is_returned
      value: "Yes"
    }
  }

  measure: item_return_rate {
    type: number
    value_format_name: percent_4
    sql: 1.0 * ${returned_count}/${count};;
  }

  measure: cumulative_total_sales {
    type: running_total
    sql: ${total_sales_price} ;;
  }

  measure: total_gross_revenue {
    type: sum
    value_format_name: usd_0
    sql: case when ${returned_raw} IS NULL and ${status} <> 'Canceled' THEN ${sale_price} ELSE 0 END ;;
  }

  measure: total_gross_margin {
    type: number
    description: "Revenue less costs excludes cancelled and returned orders"
    value_format_name: usd_0
    sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
  }

  measure: gross_margin_percentage {
    description: "Total Gross Margin divied by Total Gross Revenue. Excludes Cancelled and Returned orders."
    type: number
    value_format_name: percent_2
    sql: ${total_gross_margin} / ${total_gross_revenue} ;;
  }

  measure: average_spend_per_customer {
    type: number
    sql: ${total_sales_price}/${users.count};;
    value_format_name: usd_0
    label: "Avg Spend Per Cust"
  }

  measure: count_of_customers_having_returns {
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field: is_returned
      value: "Yes"
    }
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name
    ]
  }
}
