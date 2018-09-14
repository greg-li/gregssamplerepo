connection: "thelook_events_redshift"

# include all the views
include: "*.view"

datagroup: greg_sandbox_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: greg_sandbox_default_datagroup

explore: bsandell {}

explore: company_list {}

explore: distribution_centers {}

explore: events {
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
}

explore: order_items {
  label: "Greg's PS Case Study OI Explore"
  fields: [ALL_FIELDS*,-products.brand]
  join: users {
    type: left_outer
    sql_on: ${order_items.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }

  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }

  join: events {
    type: left_outer
    sql_on: ${users.id} = ${events.user_id} ;;
    relationship: one_to_many
  }

  join: user_order_facts {
    type: left_outer
    sql_on: ${users.id} = ${user_order_facts.user_id} ;;
    relationship: one_to_one
  }

  join: sequential_order_facts {
    type: left_outer
    sql_on: ${order_items.order_id} = ${sequential_order_facts.order_id}
            and ${order_items.user_id} = ${sequential_order_facts.user_id};;
            relationship: many_to_many
  }
}

explore: products {
  fields: [ALL_FIELDS*, -order_items.average_spend_per_customer, -order_items.percent_of_customers_with_returns, -products.brand_with_link]
  join: distribution_centers {
    type: left_outer
    sql_on: ${products.distribution_center_id} = ${distribution_centers.id} ;;
    relationship: many_to_one
  }
  join: inventory_items {
    type: left_outer
    sql_on: ${products.id} = ${inventory_items.product_id} ;;
    relationship: one_to_many
  }
  join: order_items {
    type: left_outer
    sql_on: ${inventory_items.id} = ${order_items.inventory_item_id} ;;
    relationship: one_to_many
  }
}

explore: users {
  fields: [ALL_FIELDS*,
#     -customers_returning_items_count
    ]
    join: user_order_facts {
      sql_on: ${users.id} = ${user_order_facts.user_id} ;;
      relationship: one_to_one
    }
    join: events {
      sql_on: ${users.id} = ${events.user_id} ;;
      relationship: one_to_many
    }
}
