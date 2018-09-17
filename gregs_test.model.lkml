connection: "thelook_events_redshift"

include: "*.view.lkml"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

# explore: order_items {
#   join: inventory_items {
#     type: full_outer
#     sql_on: order_items.inventory_item_id = inventory_items.id;;
#     relationship: one_to_one
#   }
#   join: users {
#     sql_on: ${order_items.user_id} = ${users.id} ;;
#     relationship: many_to_one
#   }
#   join: distribution_centers {
#     sql_on: ${distribution_centers.id} = ${inventory_items.product_distribution_center_id};;
#     relationship: one_to_many
#   }
#   join: user_order_facts_test {
#     sql_on: ${user_order_facts_test.user_id} = ${order_items.user_id} ;;
#     relationship: many_to_one
#   }
# }
