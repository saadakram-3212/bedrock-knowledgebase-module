variable "knowledge_bases" {
  description = "List of AWS Bedrock Knowledge Base configurations with OpenSearch Serverless"
  type = list(object({
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

    # Vector Ingestion Configuration
    create_vector_ingestion_configuration = optional(bool, false)
    create_custom_tranformation_config    = optional(bool, false)
    create_parsing_configuration          = optional(bool, false)

    # Chunking Strategy Configuration
    chunking_strategy                    = optional(string, null)
    chunking_strategy_max_tokens         = optional(number, null)
    chunking_strategy_overlap_percentage = optional(number, null)
    
    # Hierarchical Chunking Configuration
    level_configurations_list   = optional(list(object({ max_tokens = number })), null)
    heirarchical_overlap_tokens = optional(number, null)
    
    # Semantic Chunking Configuration
    breakpoint_percentile_threshold = optional(number, null)
    semantic_buffer_size            = optional(number, null)
    semantic_max_tokens             = optional(number, null)

    # Custom Transformation Configuration
    s3_location_uri = optional(string, null)
    transformations_list = optional(list(object({
      step_to_apply = optional(string)
      transformation_function = optional(object({
        transformation_lambda_configuration = optional(object({
          lambda_arn = optional(string)
        }))
      }))
    })), null)

    # Parsing Configuration
    parsing_config_model_arn = optional(string, null)
    parsing_prompt_text      = optional(string, null)
    parsing_strategy         = optional(string, null)

    # Context Enrichment Configuration
    create_context_enrichment_config = optional(bool, false)
    context_enrichment_type          = optional(string, null)
    context_enrichment_model_arn     = optional(string, null)
    enrichment_strategy_method       = optional(string, null)

    # Bedrock Data Automation Configuration
    create_bedrock_data_automation_config = optional(bool, false)
    parsing_modality                      = optional(string, null)

    # IAM Configuration
    permissions_boundary_arn = optional(string, null)
  }))
  default = []
}