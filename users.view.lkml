include: "order_items.view"

view: users {
  sql_table_name: public.users ;;

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
  }

  dimension: city {
    group_label: " Location"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    group_label: " Location"
    alias: [cnty]
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
      year,
      day_of_month
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    group_label: "  User Info"
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    group_label: "  User Info"
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: latitude {
    group_label: "   Lat Long"
    type: number
    sql: ${TABLE}.latitude ;;
  }

  dimension: longitude {
    group_label: "     Lat Long"
    type: number
    sql: ${TABLE}.longitude ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
  }

  dimension: traffic_source {
    type: string
    sql: ${TABLE}.traffic_source ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
    html: {{rendered_value}} {{average_months_since_signup._rendered_value}} ;;
  }

  dimension: days_since_signup {
    type: number
    sql: datediff(day,${created_date},current_date) ;;
  }

  dimension: months_since_signup {
    type: number
    sql: datediff(month,${created_date},current_date) ;;
  }

  dimension: is_new_user {
    type: yesno
    description: "90 days or less since signup"
    sql: ${days_since_signup} <= 90   ;;
  }

  dimension_group: today {
    type: time
    sql: current_date ;;
  }

  measure: count {
    type: count
    drill_fields: [id, first_name, last_name, events.count, order_items.count]
  }


#   measure: customers_returning_items_count {
#     type: count
#     filters: {
#       field: order_items.is_returned
#       value: "Yes"
#     }
#   }

  measure: average_days_since_signup {
    type: average
    sql: ${days_since_signup} ;;
  }

  measure: average_months_since_signup {
    type: average
    sql: ${months_since_signup} ;;
  }

  dimension: age_tier {
    type: tier
    style: integer
    tiers: [15,26,36,51,66]
    sql: ${age} ;;
  }
  dimension: full_name {
    type: string
    sql: ${first_name} || ' ' || ${last_name} ;;
    drill_fields: [user_drill*]
  }

  set: user_drill {fields:[is_new_user,age, age_tier,gender,days_since_signup, email, city, country]}
}
