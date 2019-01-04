view: order_items {
  sql_table_name: public.order_items ;;

# my cool name {
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

# }
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

  dimension: sale_price_tier {
    type: tier
    style: integer
    sql: ${sale_price} ;;
    tiers: [75,150,300,500]
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

##Top 20 results with and without sort
  measure: count {
    type: count
    drill_fields: [detail*]
    link: {label: "Explore Top 20 Results" url: "{{ link }}&limit=20" }
    link: {label: "Explore Top 20 Results by Sale Price" url: "{{ link }}&sorts=order_items.sale_price+desc&limit=20" }
  }

  measure: order_count {
    type: count_distinct
    drill_fields: [created_year, users.age_tier, total_sales_price]
    link: {label: "Total Sale Price by Month for each Age Tier" url: "{{link}}&pivots=users.age_tier"}
    sql: ${order_id} ;;
  }

  measure: count_of_items_demo_3 {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [created_date, total_sales_price]
  }

  measure: count_of_items_demo_4 {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [users.state,order_items.order_count,order_items.average_spend_per_customer]
    link: {label:"Drill into orders by state by order count and avg spend" url: "{{link}}&limit=15&column_limit=50&vis=%7B%22stacking%22%3A%22%22%2C%22show_value_labels%22%3Afalse%2C%22label_density%22%3A25%2C%22legend_position%22%3A%22center%22%2C%22x_axis_gridlines%22%3Afalse%2C%22y_axis_gridlines%22%3Atrue%2C%22show_view_names%22%3Atrue%2C%22point_style%22%3A%22circle%22%2C%22series_types%22%3A%7B%7D%2C%22limit_displayed_rows%22%3Afalse%2C%22y_axes%22%3A%5B%7B%22label%22%3A%22%22%2C%22orientation%22%3A%22left%22%2C%22series%22%3A%5B%7B%22id%22%3A%22order_items.total_gross_revenue%22%2C%22name%22%3A%22Total+Gross+Revenue%22%2C%22axisId%22%3A%22order_items.total_gross_revenue%22%7D%2C%7B%22id%22%3A%22order_items.order_count%22%2C%22name%22%3A%22Order+Count%22%2C%22axisId%22%3A%22order_items.order_count%22%7D%5D%2C%22showLabels%22%3Atrue%2C%22showValues%22%3Atrue%2C%22unpinAxis%22%3Afalse%2C%22tickDensity%22%3A%22default%22%2C%22type%22%3A%22linear%22%7D%2C%7B%22label%22%3Anull%2C%22orientation%22%3A%22right%22%2C%22series%22%3A%5B%7B%22id%22%3A%22order_items.average_spend_per_customer%22%2C%22name%22%3A%22Avg+Spend+Per+Cust%22%2C%22axisId%22%3A%22order_items.average_spend_per_customer%22%7D%5D%2C%22showLabels%22%3Atrue%2C%22showValues%22%3Atrue%2C%22unpinAxis%22%3Afalse%2C%22tickDensity%22%3A%22default%22%2C%22type%22%3A%22linear%22%7D%5D%2C%22y_axis_combined%22%3Atrue%2C%22show_y_axis_labels%22%3Atrue%2C%22show_y_axis_ticks%22%3Atrue%2C%22y_axis_tick_density%22%3A%22default%22%2C%22y_axis_tick_density_custom%22%3A5%2C%22show_x_axis_label%22%3Atrue%2C%22show_x_axis_ticks%22%3Atrue%2C%22x_axis_scale%22%3A%22auto%22%2C%22y_axis_scale_mode%22%3A%22linear%22%2C%22x_axis_reversed%22%3Afalse%2C%22y_axis_reversed%22%3Afalse%2C%22plot_size_by_field%22%3Afalse%2C%22ordering%22%3A%22none%22%2C%22show_null_labels%22%3Afalse%2C%22show_totals_labels%22%3Afalse%2C%22show_silhouette%22%3Afalse%2C%22totals_color%22%3A%22%23808080%22%2C%22type%22%3A%22looker_scatter%22%7D&filter_config=%7B%7D&origin=share-expanded"}
  }

  measure: total_sales_price {
    type: sum
    value_format_name: usd
    sql: ${sale_price} ;;
  }

  measure: average_sales_price {
    type: average
    value_format_name: usd
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
    value_format_name: usd
    sql: ${total_sales_price} ;;
  }

  measure: total_gross_revenue {
    type: sum
    value_format_name: usd_0
    sql: case when ${returned_raw} IS NULL and ${status} <> 'Canceled' THEN ${sale_price} ELSE 0 END ;;
  }

  measure: total_gross_revenue_brand {
    type: number
    value_format_name: usd_0
    sql: case when ${products.brand} = {{products.brand_filter._value}} then ${total_gross_revenue} END ;;
  }

#   measure: gross_revenue_percentage {
#     type: percent_of_total
#     sql: 1.0*${total_gross_revenue} ;;
#   }

  measure: total_gross_margin {
    type: number
    description: "Revenue less costs excludes cancelled and returned orders"
    value_format_name: usd_0
    sql: ${total_gross_revenue} - ${inventory_items.total_cost} ;;
  }

  measure: average_gross_margin {
    type: average
    value_format_name: usd
    drill_fields: [products.category, products.brand, average_gross_margin]
    sql: case when ${returned_raw} IS NULL and ${status} <> 'Canceled' THEN ${sale_price} ELSE 0 END - ${inventory_items.cost} ;;
  }

  measure: gross_margin_percentage {
    description: "Total Gross Margin divied by Total Gross Revenue. Excludes Cancelled and Returned orders."
    type: number
    value_format_name: percent_2
    sql: case when ${total_gross_revenue} = 0 then 0
    else ${total_gross_margin} / ${total_gross_revenue} end ;;
    drill_fields: [detail*, products.products*]
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

  measure: percent_of_customers_with_returns{
    type: number
    value_format_name: percent_2
    sql: 1.0 * ${count_of_customers_having_returns}/${users.count} ;;
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      users.id,
      users.first_name,
      users.last_name,
      inventory_items.id,
      inventory_items.product_name,
      sale_price,
      sale_price_tier
    ]
  }
}
