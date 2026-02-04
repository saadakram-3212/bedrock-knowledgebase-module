# Kendra Index Outputs

output "kendra_index_arn" {
  description = "The ARN of the created Kendra index"
  value       = var.create_kendra_config && var.kendra_index_arn == null ? awscc_kendra_index.genai_kendra_index[0].arn : var.kendra_index_arn
}

output "kendra_index_id" {
  description = "The ID of the created Kendra index"
  value       = var.create_kendra_config && var.kendra_index_arn == null ? awscc_kendra_index.genai_kendra_index[0].id : null
}

# Conditional output - only shows if index was created
output "created_kendra_index" {
  description = "Whether a new Kendra index was created"
  value       = var.create_kendra_config && var.kendra_index_arn == null ? true : false
}

# Data source outputs (commented since they're not in the provided code)
# output "kendra_data_source_id" {
#   description = "The ID of the created Kendra data source"
#   value       = var.create_kendra_s3_data_source ? awscc_kendra_data_source.kendra_s3_data_source[0].id : null
# }
# 
# output "kendra_data_source_arn" {
#   description = "The ARN of the created Kendra data source"
#   value       = var.create_kendra_s3_data_source ? awscc_kendra_data_source.kendra_s3_data_source[0].arn : null
# }