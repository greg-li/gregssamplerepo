connection: "biquery_publicdata_standard_sql"
include: "views/users.view"

explore: users {
  aggregate_table: state_info {
    query: {
      dimensions: [users.city]
      measures: [users.count]
    }
    materialization: {persist_for: "1 hours"}
  }
}
