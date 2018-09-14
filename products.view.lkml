view: products {
  sql_table_name: public.products ;;

  parameter: brand_filter {
    type: string
    suggest_dimension: brand
  }

  parameter: category_filter {
    type: string
    suggest_dimension: category
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: brand_with_link {
    label: "Brand"
    type: string
    link: {
      label: "Brand Performance Detail"
      url: "https://profservices.dev.looker.com/dashboards/55?category=&Brand%20Filter={{ value }}"
    }
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: distribution_center_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.distribution_center_id ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: brand_versus_all_other {
    sql: case when {% parameter brand_filter %} = ${brand} then ${brand}
    else 'Other' END;;
  }

  set: products {
    fields: [brand,department,retail_price,distribution_center_id,sku]
  }

  measure: count_brands {
    type: count_distinct
    sql: ${brand} ;;
  }


  measure: count {
    type: count
    drill_fields: [id, name, distribution_centers.id, distribution_centers.name, inventory_items.count]
  }
}
