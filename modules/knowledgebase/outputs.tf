output "knowledge_base_id" {
  description = "The ID of the Bedrock Knowledge Base"
  value       = var.create_default_kb ? awscc_bedrock_knowledge_base.knowledge_base_default[0].knowledge_base_id : (var.create_kendra_config ? awscc_bedrock_knowledge_base.knowledge_base_kendra[0].knowledge_base_id : null)
}

output "knowledge_base_arn" {
  description = "The ARN of the Bedrock Knowledge Base"
  value       = var.create_default_kb ? awscc_bedrock_knowledge_base.knowledge_base_default[0].knowledge_base_arn : (var.create_kendra_config ? awscc_bedrock_knowledge_base.knowledge_base_kendra[0].knowledge_base_arn : null)
}

output "opensearch_collection_arn" {
  description = "The ARN of the OpenSearch Serverless Collection"
  value       = var.create_default_kb ? awscc_opensearchserverless_collection.os_collection[0].arn : null
}

output "opensearch_collection_id" {
  description = "The ID of the OpenSearch Serverless Collection"
  value       = var.create_default_kb ? awscc_opensearchserverless_collection.os_collection[0].id : null
}

output "opensearch_collection_name" {
  description = "The name of the OpenSearch Serverless Collection"
  value       = var.create_default_kb ? awscc_opensearchserverless_collection.os_collection[0].name : null
}

output "opensearch_collection_endpoint" {
  description = "The endpoint of the OpenSearch Serverless Collection"
  value       = var.create_default_kb ? awscc_opensearchserverless_collection.os_collection[0].collection_endpoint : null
}

output "vector_index_name" {
  description = "The name of the vector index"
  value       = var.create_default_kb ? opensearch_index.vector_index[0].name : null
}

output "bedrock_kb_role_arn" {
  description = "The ARN of the IAM role for Bedrock Knowledge Base"
  value       = aws_iam_role.bedrock_knowledge_base_role.arn
}






output "knowledge_base_name" {
  description = "The name of the knowledge base"
  value       = var.create_default_kb ? awscc_bedrock_knowledge_base.knowledge_base_default[0].name : (var.create_kendra_config ? awscc_bedrock_knowledge_base.knowledge_base_kendra[0].name : null)
}
# Data Source Outputs
output "data_source_id" {
  description = "The ID of the Bedrock data source"
  value       = var.create_s3_data_source ? awscc_bedrock_data_source.knowledge_base_ds[0].data_source_id : null
}

output "data_source_name" {
  description = "The name of the Bedrock data source"
  value       = var.create_s3_data_source ? awscc_bedrock_data_source.knowledge_base_ds[0].name : null
}

# IAM Role Outputs
output "bedrock_kb_role_name" {
  description = "The name of the IAM role for the Bedrock Knowledge Base"
  value       = aws_iam_role.bedrock_knowledge_base_role.name
}