connection: "thelook_events_redshift"

include: "/*.view"                       # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

explore: order_items {
  fields: [id]
}

explore: user_order_facts_2 {
  view_name: user_order_facts
}
