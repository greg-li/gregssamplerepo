connection: "biquery_publicdata_standard_sql"
include: "views/users.view"

datagroup: every_five {
  sql_trigger: SELECT floor(EXTRACT(minute FROM CURRENT_TIMESTAMP())/5) ;;
}


# push to prod and then try this with triggers
explore: users {
  persist_for: "0 minutes"
  aggregate_table: state_info {
    query: {
      dimensions: [users.city]
      measures: [users.count]
    }
    materialization: {datagroup_trigger:every_five}
  }
}
