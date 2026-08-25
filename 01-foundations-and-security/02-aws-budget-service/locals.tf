locals {
  formatted_tag_filters = flatten([
    for key, values in var.cost_filter_tags : [
      for val in values : "${key}$${val}"
    ]
  ])
}