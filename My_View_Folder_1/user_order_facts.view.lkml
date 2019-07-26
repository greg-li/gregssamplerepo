explore: user_order_facts {}
view: user_order_facts {
  derived_table: {
    sql: select
        user_id as user_id,
        count(distinct order_id) as total_lifetime_orders,
        sum(case when returned_at IS NULL and status <> 'Canceled' THEN sale_price ELSE 0 END) as total_lifetime_revenue,
        min(created_at) as first_order_date,
        max(created_at) as latest_order_date,
        case when count(distinct order_id) > 1 then 'Yes' else 'No' END as is_repeat
      from order_items
      group by 1
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    primary_key: yes
    sql: ${TABLE}.user_id ;;
  }

  dimension: total_lifetime_orders {
    type: number
    sql: ${TABLE}.total_lifetime_orders ;;
  }

  dimension: total_lifetime_revenue {
    type: number
    sql: ${TABLE}.total_lifetime_revenue ;;
  }

  dimension_group: first_order {
    type: time
    sql: ${TABLE}.first_order_date ;;
  }

  dimension_group: latest_order{
    type: time
    sql: ${TABLE}.latest_order_date ;;
  }

  set: detail {
    fields: [user_id, total_lifetime_orders, total_lifetime_revenue, first_order_time, latest_order_time]
  }


  dimension: customer_lifetime_order_tier {
    type: tier
    style: integer
    tiers: [1,2,3,6,10]
    sql: ${total_lifetime_orders} ;;
  }

  dimension: customer_lifetime_revenue_tier {
    type: tier
    style: integer
    tiers: [0,5,20,50,100,500,1000]
    sql: ${total_lifetime_revenue} ;;
  }

  dimension: days_since_latest_order_date {
    type: number
    sql: datediff(day,${latest_order_date},current_date) ;;
  }

  dimension: is_active {
    type: yesno
    sql: ${days_since_latest_order_date} <= 90 ;;
  }

  dimension: is_repeat_customer {
    type: string
    sql: ${TABLE}.is_repeat;;
    drill_fields: [detail*]
  }


  measure: average_lifetime_orders{
    type: average
    sql: ${total_lifetime_orders} ;;
  }

  measure: average_lifetime_revenue{
    type: average
    value_format_name: usd
    sql: ${total_lifetime_revenue} ;;
  }


  measure: average_days_since_last_order{
    type: average
    sql: ${days_since_latest_order_date} ;;
  }
}
