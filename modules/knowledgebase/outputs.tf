output "default_collection" {
  value       = var.create_default_kb ? module.oss_knowledgebase[0].opensearch_serverless_collection : null
  description = "Opensearch default collection value."
}

output "vector_index" {
  value       = var.create_default_kb ? module.oss_knowledgebase[0].vector_index : null
  description = "Opensearch default vector index value in collection."
}

output "opensearch_serverless_data_policy" {
  value       = var.create_default_kb ? module.oss_knowledgebase[0].opensearch_serverless_data_policy : null
  description = "Opensearch opensearch serverless collection data policy."
}

