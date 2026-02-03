# – Knowledge Base Configuration –

variable "create_default_kb" {
  description = "Whether or not to create the default knowledge base."
  type        = bool
  default     = false
}

variable "kb_name" {
  description = "Name of the knowledge base."
  type        = string
  default     = "knowledge-base"
}

variable "kb_description" {
  description = "Description of knowledge base."
  type        = string
  default     = "Terraform deployed Knowledge Base"
}

variable "kb_role_arn" {
  description = "The ARN of the IAM role with permission to invoke API operations on the knowledge base. If not provided, a new role will be created."
  type        = string
  default     = null
}

variable "kb_tags" {
  description = "A map of tags keys and values for the knowledge base."
  type        = map(string)
  default     = null
}

# – OpenSearch Serverless Configuration –

variable "allow_opensearch_public_access" {
  description = "Whether or not to allow public access to the OpenSearch collection endpoint and the Dashboards endpoint."
  type        = bool
  default     = true
}

variable "number_of_shards" {
  description = "The number of shards for the OpenSearch index. This setting cannot be changed after index creation."
  type        = string
  default     = "1"
}

variable "number_of_replicas" {
  description = "The number of replica shards for the OpenSearch index."
  type        = string
  default     = "1"
}

variable "vector_dimension" {
  description = "The dimension of vectors in the OpenSearch index. Use 1024 for Titan Text Embeddings V2, 1536 for V1"
  type        = number
  default     = 1024
}

# – Knowledge Base Storage Configuration –

variable "metadata_field" {
  description = "The name of the field in which Amazon Bedrock stores metadata about the vector store."
  type        = string
  default     = "AMAZON_BEDROCK_METADATA"
}

variable "text_field" {
  description = "The name of the field in which Amazon Bedrock stores the raw text from your data."
  type        = string
  default     = "AMAZON_BEDROCK_TEXT_CHUNK"
}

variable "vector_field" {
  description = "The name of the field where the vector embeddings are stored"
  type        = string
  default     = "bedrock-knowledge-base-default-vector"
}

# – Knowledge Base Embedding Configuration –

variable "kb_embedding_model_arn" {
  description = "The ARN of the model used to create vector embeddings for the knowledge base."
  type        = string
  default     = "arn:aws:bedrock:us-east-1::foundation-model/amazon.titan-embed-text-v2:0"
}

variable "embedding_model_dimensions" {
  description = "The dimensions details for the vector configuration used on the Bedrock embeddings model."
  type        = number
  default     = null
}

variable "embedding_data_type" {
  description = "The data type for the vectors when using a model to convert text into vector embeddings."
  type        = string
  default     = null
}

# – Supplemental Data Storage Configuration –

variable "create_supplemental_data_storage" {
  description = "Whether or not to create supplemental data storage configuration."
  type        = bool
  default     = false
}

variable "supplemental_data_s3_uri" {
  description = "The S3 URI for supplemental data storage."
  type        = string
  default     = null
}

# – IAM Configuration –

variable "permissions_boundary_arn" {
  description = "The ARN of the IAM permission boundary for the role."
  type        = string
  default     = null
}
# Data Source Configuration
variable "create_s3_data_source" {
  description = "Whether or not to create the S3 data source."
  type        = bool
  default     = false
}

variable "data_source_description" {
  description = "Description of the data source."
  type        = string
  default     = null
}

variable "data_deletion_policy" {
  description = "Policy for deleting data from the data source. Can be either DELETE or RETAIN."
  type        = string
  default     = "DELETE"
}

variable "kb_s3_data_source" {
  description = "The S3 data source ARN for the knowledge base."
  type        = string
  default     = null
}

variable "server_side_encryption_configuration" {
  description = "Configuration for server-side encryption."
  type        = any
  default     = null
}

variable "create_vector_ingestion_configuration" {
  description = "Whether or not to create a vector ingestion configuration."
  type        = bool
  default     = false
}

# – Data Source Vector Ingestion Configuration –


variable "create_custom_tranformation_config" {
  description = "Whether or not to create a custom transformation configuration."
  type        = bool
  default     = false
}

variable "create_parsing_configuration" {
  description = "Whether or not to create a parsing configuration."
  type        = bool
  default     = false
}

variable "chunking_strategy" {
  description = "Knowledge base can split your source data into chunks. A chunk refers to an excerpt from a data source that is returned when the knowledge base that it belongs to is queried. You have the following options for chunking your data. If you opt for NONE, then you may want to pre-process your files by splitting them up such that each file corresponds to a chunk."
  type        = string
  default     = null
}

variable "chunking_strategy_max_tokens" {
  description = "The maximum number of tokens to include in a chunk."
  type        = number
  default     = null
}

variable "chunking_strategy_overlap_percentage" {
  description = "The percentage of overlap between adjacent chunks of a data source."
  type        = number
  default     = null
}

variable "level_configurations_list" {
  description = "Token settings for each layer."
  type        = list(object({ max_tokens = number }))
  default     = null
}

variable "heirarchical_overlap_tokens" {
  description = "The number of tokens to repeat across chunks in the same layer."
  type        = number
  default     = null
}

variable "breakpoint_percentile_threshold" {
  description = "The dissimilarity threshold for splitting chunks."
  type        = number
  default     = null
}

variable "semantic_buffer_size" {
  description = "The buffer size."
  type        = number
  default     = null
}

variable "semantic_max_tokens" {
  description = "The maximum number of tokens that a chunk can contain."
  type        = number
  default     = null
}

variable "s3_location_uri" {
  description = "A location for storing content from data sources temporarily as it is processed by custom components in the ingestion pipeline."
  type        = string
  default     = null
}

variable "transformations_list" {
  description = "A list of Lambda functions that process documents."
  type = list(object({
    step_to_apply = optional(string)
    transformation_function = optional(object({
      transformation_lambda_configuration = optional(object({
        lambda_arn = optional(string)
      }))
    }))
  }))
  default = null
}

variable "parsing_config_model_arn" {
  description = "The model's ARN."
  type        = string
  default     = null
}

variable "parsing_prompt_text" {
  description = "Instructions for interpreting the contents of a document."
  type        = string
  default     = null
}

variable "parsing_strategy" {
  description = "The parsing strategy for the data source."
  type        = string
  default     = null
}

variable "create_context_enrichment_config" {
  description = "Whether or not to create context enrichment configuration for the data source."
  type        = bool
  default     = false
}

variable "context_enrichment_type" {
  description = "Enrichment type to be used for the vector database."
  type        = string
  default     = null
}

variable "context_enrichment_model_arn" {
  description = "The model's ARN for context enrichment."
  type        = string
  default     = null
}

variable "enrichment_strategy_method" {
  description = "Enrichment Strategy method."
  type        = string
  default     = null
}

variable "parsing_modality" {
  description = "Determine how parsed content will be stored."
  type        = string
  default     = null
}

variable "create_bedrock_data_automation_config" {
  description = "Whether or not to create Bedrock Data Automation configuration for the data source."
  type        = bool
  default     = false
}