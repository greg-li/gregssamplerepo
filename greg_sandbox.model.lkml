connection: "thelook_events_redshift"
access_grant: brand {
  user_attribute: brand
  allowed_values: ["Calvin Klein"]

}

access_grant: department {
  user_attribute: department
  allowed_values: ["testnothugo"]
}




# include all the views
include: "*.view"

persist_with: greg_sandbox_default_datagroup

explore: bsandell {}

explore: company_list {}

# explore: users_ext {}

explore: distribution_centers {}

explore: events {
  label: "Events +"
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
  label: "Greg's Sandbox Order Item Explore"
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
#   access_filter: {
#     field: brand
# #     user_attribute: brand
#   }
sql_always_where: case when '\{{ _user_attributes['brand'] }}' = '\%' then 1=1
  when  position( ',' in '\{{ _user_attributes['brand'] }}' ) <> 0 then ${brand} in ({{ _user_attributes['brand'] }})
  else
  '\{{ _user_attributes['brand'] }}' = ${brand} END;;
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

# explore: users {
#   fields: [ALL_FIELDS*,
# #     -customers_returning_items_count
#     ]
#     join: user_order_facts {
#       sql_on: ${users.id} = ${user_order_facts.user_id} ;;
#       relationship: one_to_one
#     }
#     join: events {
#       sql_on: ${users.id} = ${events.user_id} ;;
#       relationship: one_to_many
#     }
# }

explore: users {
#   join: users_ext {
#     view_label: "Users"
#   sql:  ;;
# relationship: one_to_one
# }
}
