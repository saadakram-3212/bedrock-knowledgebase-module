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