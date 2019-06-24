include: "order_items.view"


view: users {
# required_access_grants: [brand]
  sql_table_name: public.users ;;

  dimension: join_alias {
    sql: ${TABLE};;
  }

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

  dimension: gender_test {
    type: string
    sql:
    case when {% condition first_name %} 'Aaron' {% endcondition %}
    then 1 else 0 end
    ;;
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
    link: {
      label: "click here deborah"
      url: "/explore/greg_sandbox/users?fields=users.gender,users.count&sorts=users.count+desc&limit=500&column_limit=50&vis=%7B%22type%22%3A%22looker_column%22%2C%22series_types%22%3A%7B%7D%7D&filter_config=%7B%7D&origin=share-expanded"
    }
  }


#   measure: customers_returning_items_count {
#     type: count
#     filters: {
#       field: order_items.is_returned
#       value: "Yes"
#     }
#   }



#   set: user_drill {fields:[is_new_user,age, age_tier,gender,days_since_signup, email, city, country]}
}
