variable "knowledge_base_config" {
  description = "Configuration for AWS Bedrock Knowledge Base with OpenSearch Serverless"
  type = object({
    # Knowledge Base Configuration
    create_default_kb = optional(bool, false)
    kb_name           = optional(string, "knowledge-base")
    kb_description    = optional(string, "Terraform deployed Knowledge Base")
    kb_role_arn       = optional(string, null)
    kb_tags           = optional(map(string), null)

    # OpenSearch Serverless Configuration
    allow_opensearch_public_access = optional(bool, true)
    number_of_shards               = optional(string, "1")
    number_of_replicas             = optional(string, "1")
    vector_dimension               = optional(number, 1024)

    # Knowledge Base Storage Configuration
    metadata_field = optional(string, "AMAZON_BEDROCK_METADATA")
    text_field     = optional(string, "AMAZON_BEDROCK_TEXT_CHUNK")
    vector_field   = optional(string, "bedrock-knowledge-base-default-vector")

    # Knowledge Base Embedding Configuration
    kb_embedding_model_arn     = optional(string, "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0")
    embedding_model_dimensions = optional(number, null)
    embedding_data_type        = optional(string, null)

    # Supplemental Data Storage Configuration
    create_supplemental_data_storage = optional(bool, false)
    supplemental_data_s3_uri         = optional(string, null)

    # Data Source Configuration
    create_s3_data_source   = optional(bool, false)
    data_source_description = optional(string, null)
    data_deletion_policy    = optional(string, "DELETE")
    kb_s3_data_source       = optional(string, null)
    server_side_encryption_configuration = optional(object({
      encryption_type = string
      kms_key_arn     = optional(string, null)
    }), null)

    # IAM Configuration
    permissions_boundary_arn = optional(string, null)
  })
  default = {}
}