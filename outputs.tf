# outputs.tf (Root)

# Knowledge Base Outputs
output "knowledge_base_ids" {
  description = "Map of knowledge base IDs indexed by their position in the list"
  value       = { for k, v in module.bedrock : k => try(v.knowledge_base_id, null) }
}

output "knowledge_base_arns" {
  description = "Map of knowledge base ARNs indexed by their position in the list"
  value       = { for k, v in module.bedrock : k => try(v.knowledge_base_arn, null) }
}

output "knowledge_base_names" {
  description = "Map of knowledge base names indexed by their position in the list"
  value       = { for k, v in module.bedrock : k => try(v.knowledge_base_name, null) }
}


# Data Source Outputs
output "data_source_ids" {
  description = "Map of Bedrock data source IDs"
  value       = { for k, v in module.bedrock : k => try(v.data_source_id, null) }
}

output "data_source_names" {
  description = "Map of Bedrock data source names"
  value       = { for k, v in module.bedrock : k => try(v.data_source_name, null) }
}

# IAM Role Outputs
output "bedrock_kb_role_arns" {
  description = "Map of IAM role ARNs for Bedrock Knowledge Bases"
  value       = { for k, v in module.bedrock : k => try(v.bedrock_kb_role_arn, null) }
}

output "bedrock_kb_role_names" {
  description = "Map of IAM role names for Bedrock Knowledge Bases"
  value       = { for k, v in module.bedrock : k => try(v.bedrock_kb_role_name, null) }
}

