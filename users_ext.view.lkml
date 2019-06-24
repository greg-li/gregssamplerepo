# include: "users.view"
# explore: users_ext {}
#
#
# view: users_ext {
# #   required_access_grants: [department]
#   measure: average_days_since_signup {
#     type: average
#     sql: ${users.days_since_signup} ;;
#   }
#
#   measure: average_months_since_signup {
#     type: average
#     sql: ${users.months_since_signup} ;;
#   }
#
#   dimension: new_age {
#     type: number
#     sql: ${users.join_alias}.age ;;
#   }
#
#   dimension: age_tier {
#     type: tier
#     style: integer
#     tiers: [15,26,36,51,66]
#     sql: ${users.age} ;;
#   }
#   dimension: full_name {
#     type: string
#     sql: ${users.first_name} || ' ' || ${users.last_name} ;;
#   }
#
# }
