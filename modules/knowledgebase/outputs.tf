output "knowledge_base_id" {
  description = "The ID of the Bedrock Knowledge Base"
  value       = var.create_default_kb ? awscc_bedrock_knowledge_base.knowledge_base_default[0].knowledge_base_id : null
}

output "knowledge_base_arn" {
  description = "The ARN of the Bedrock Knowledge Base"
  value       = var.create_default_kb ? awscc_bedrock_knowledge_base.knowledge_base_default[0].knowledge_base_arn : null
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