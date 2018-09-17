explore: sequential_order_facts {
#   join: sequential_order_facts_next_order {
#     from: sequential_order_facts
#     sql_on: ${sequential_order_facts.order_sequence} + 1 = ${sequential_order_facts_next_order.order_sequence}  ;;
#   }
}



view: sequential_order_facts {
  derived_table: {
    sql: select distinct
        row_number() over() as pk,
        user_id,
        order_id,
        created_at,
        row_number() over (partition by user_id order by created_at) as order_sequence,
        lag(created_at,1) OVER (partition by user_id order by created_at)   as previous_order_date,
        lead(created_at) OVER (partition by user_id order by created_at)   as subsequent_order_date
      from order_items
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: user_id {
    type: number
    sql: ${TABLE}.user_id ;;
  }

  dimension: order_id {
    type: number
    sql: ${TABLE}.order_id ;;
  }

  dimension: primary_key {
    type: string
    primary_key: yes
    sql:  ${TABLE}.pk ;;
  }

  dimension_group: created_at {
    type: time
    sql: ${TABLE}.created_at ;;
  }

  dimension: order_sequence {
    type: number
    sql: ${TABLE}.order_sequence ;;
  }

  dimension_group: previous_order {
    type: time
    sql: ${TABLE}.previous_order_date ;;
  }

  dimension_group: subsequent_order {
    type: time
    sql: ${TABLE}.subsequent_order_date ;;
  }

  dimension: days_between_orders {
    type: number
    sql: case when ${previous_order_date} is NULL then null
      ELSE datediff(day,${previous_order_date},${created_at_date}) END;;
  }

  dimension: is_first_order {
    type: yesno
    sql: ${order_sequence} = 1 ;;
  }

  dimension: has_subsequent_order {
    type: yesno
    sql: ${subsequent_order_date} IS NOT NULL ;;
  }

#   dimension: days_between_next_order {
#     type: number
#     sql: datediff(day,${days_between_orders},${sequential_order_facts_next_order.days_between_orders} ;;
#   }

  measure: average_days_between_orders{
    type: average
    value_format_name: decimal_0
    sql: ${days_between_orders};;
    drill_fields: [detail*]
  }

  measure: sixty_day_repeat_order_user_count{
    type: count_distinct
    sql: ${user_id} ;;
    filters: {
      field:days_between_orders
      value: "<=60"
    }
  }

  measure: user_count {
    type: count_distinct
    sql: ${user_id} ;;
  }

  set: detail {
    fields: [
      user_id,
      order_id,
      created_at_time,
      order_sequence,
      previous_order_date,
      subsequent_order_date
    ]
  }
}
