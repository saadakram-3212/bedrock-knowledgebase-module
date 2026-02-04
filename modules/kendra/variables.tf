# – Kendra GenAI Knowledge Base – 

variable "create_kendra_config" {
  description = "Whether or not to create a Kendra GenAI knowledge base."
  type        = bool
  default     = false
}

variable "kendra_index_arn" {
  description = "The ARN of the existing Kendra index."
  type        = string
  default     = null
}

# ========== NOT USED IN PROVIDED CODE ==========
# variable "kendra_index_id" {
#   description = "The ID of the existing Kendra index."
#   type        = string
#   default     = null
# }
# ===============================================

variable "kendra_index_name" {
  description = "The name of the Kendra index."
  type        = string
  default     = "test-index"
}

variable "kendra_index_edition" {
  description = "The Amazon Kendra Edition to use for the index."
  type        = string
  default     = "DEVELOPER_EDITION"

  validation {
    condition     = var.kendra_index_edition == "DEVELOPER_EDITION" || var.kendra_index_edition == "ENTERPRISE_EDITION" || var.kendra_index_edition == "GEN_AI_ENTERPRISE_EDITION"
    error_message = "Kendra index edition must be DEVELOPER_EDITION, ENTERPRISE_EDITION or GEN_AI_ENTERPRISE_EDITION."
  }
}

variable "kendra_index_description" {
  description = "A description for the Kendra index."
  type        = string
  default     = null
}

variable "kendra_index_query_capacity" {
  description = "The number of queries per second allowed for the Kendra index."
  type        = number
  default     = 1

  validation {
    condition     = var.kendra_index_query_capacity >= 1 && var.kendra_index_query_capacity <= 100
    error_message = "Kendra index query capacity must be between 1 and 100."
  }
}

variable "kendra_index_storage_capacity" {
  description = "The storage capacity of the Kendra index."
  type        = number
  default     = 1

  validation {
    condition     = var.kendra_index_storage_capacity >= 1 && var.kendra_index_storage_capacity <= 50
    error_message = "Kendra index storage capacity must be between 1 and 50."
  }
}

variable "kendra_index_tags" {
  description = "A map of tag keys and values for Kendra index."
  type        = list(map(string))
  default     = null
}

variable "user_token_configurations" {
  description = "List of user token configurations for Kendra."
  type = list(object({

    json_token_type_configurations = optional(object({
      group_attribute_field     = string
      user_name_attribute_field = string
    }))

    jwt_token_type_configuration = optional(object({
      claim_regex               = optional(string)
      key_location              = optional(string)
      group_attribute_field     = optional(string)
      user_name_attribute_field = optional(string)
      issuer                    = optional(string)
      secret_manager_arn        = optional(string)
      url                       = optional(string)
    }))

  }))
  default = null
}

variable "kendra_kms_key_id" {
  description = "The Kendra index is encrypted at rest using this key. Specify the key ARN."
  type        = string
  default     = null
}

variable "kendra_index_user_context_policy" {
  description = "The Kendra index user context policy."
  type        = string
  default     = null
}

variable "document_metadata_configurations" {
  description = "List of document metadata configurations for Kendra."
  type = list(object({
    name = optional(string)
    type = optional(string)
    search = optional(object({
      facetable   = optional(bool)
      searchable  = optional(bool)
      displayable = optional(bool)
      sortable    = optional(bool)
    }))
    relevance = optional(object({
      duration   = optional(string)
      freshness  = optional(bool)
      importance = optional(number)
      rank_order = optional(string)
      value_importance_items = optional(list(object({
        key   = optional(string)
        value = optional(number)
      })))
    }))
  }))
  default = null
}

variable "kendra_index_role_arn" {
  description = "The ARN of the IAM role that Kendra will assume when accessing the data source."
  type        = string
  default     = null
}

# ========== KENDRA DATA SOURCE VARIABLES (NOT USED IN PROVIDED CODE) ==========

# variable "kendra_data_source_name" {
#   description = "The name of the Kendra data source."
#   type        = string
#   default     = "kendra-data-source"
# }

# variable "kendra_data_source_language_code" {
#   description = "The code for the language of the Kendra data source content."
#   type        = string
#   default     = "en"
# }

# variable "kendra_data_source_description" {
#   description = "A description for the Kendra data source."
#   type        = string
#   default     = null
# }

# variable "kendra_data_source_tags" {
#   description = "A map of tag keys and values for Kendra data source."
#   type        = list(map(string))
#   default     = null
# }

# variable "kendra_data_source_schedule" {
#   description = "The schedule for Amazon Kendra to update the index."
#   type        = string
#   default     = null
# }

# variable "s3_data_source_exclusion_patterns" {
#   description = "A list of glob patterns to exclude from the data source."
#   type        = list(string)
#   default     = null
# }

# variable "s3_data_source_inclusion_patterns" {
#   description = "A list of glob patterns to include in the data source."
#   type        = list(string)
#   default     = null
# }

# variable "s3_data_source_document_metadata_prefix" {
#   description = "The prefix for the S3 data source."
#   type        = string
#   default     = null
# }

# variable "s3_data_source_key_path" {
#   description = "The S3 key path where for the data source."
#   type        = string
#   default     = null
# }

# variable "s3_data_source_bucket_name" {
#   description = "The name of the S3 bucket where the data source is stored."
#   type        = string
#   default     = null
# }

# variable "create_kendra_s3_data_source" {
#   description = "Whether or not to create a Kendra S3 data source."
#   type        = bool
#   default     = false
# }
# ==============================================================================


# Kendra Web Crawler Variables
variable "create_kendra_web_crawler" {
  description = "Whether to create a Kendra web crawler data source"
  type        = bool
  default     = false
}

variable "kendra_web_crawler_description" {
  description = "Description for the Kendra web crawler"
  type        = string
  default     = "Kendra web crawler data source"
}

variable "kendra_datasource_role_arn" {
  description = "IAM role ARN for Kendra data source"
  type        = string
  default     = null
}

variable "kendra_web_crawler_schedule" {
  description = "Schedule for web crawler (cron expression)"
  type        = string
  default     = null # e.g., "cron(0 12 * * ? *)"
}

variable "seed_urls" {
  description = "List of seed URLs for web crawler"
  type        = list(string)
  default     = []
}

variable "web_crawler_mode" {
  description = "Web crawler mode: HOST_ONLY, SUBDOMAINS, or EVERYTHING"
  type        = string
  default     = "HOST_ONLY"
}

variable "site_maps" {
  description = "List of sitemap URLs"
  type        = list(string)
  default     = null
}

variable "crawl_depth" {
  description = "Depth of web crawling (0-10)"
  type        = number
  default     = 2
}

variable "max_links_per_page" {
  description = "Maximum number of links per page to crawl"
  type        = number
  default     = 100
}

variable "max_content_size_per_page" {
  description = "Maximum content size per page in megabytes"
  type        = number
  default     = 50
}

variable "max_urls_per_minute" {
  description = "Maximum URLs to crawl per minute"
  type        = number
  default     = 300
}

variable "url_inclusion_patterns" {
  description = "URL patterns to include in crawling"
  type        = list(string)
  default     = null
}

variable "url_exclusion_patterns" {
  description = "URL patterns to exclude from crawling"
  type        = list(string)
  default     = null
}

variable "proxy_host" {
  description = "Proxy host for web crawler"
  type        = string
  default     = null
}

variable "proxy_port" {
  description = "Proxy port for web crawler"
  type        = number
  default     = null
}

variable "proxy_credentials_secret_arn" {
  description = "ARN of secret containing proxy credentials"
  type        = string
  default     = null
}

variable "basic_auth_configs" {
  description = "List of basic authentication configurations for websites"
  type = list(object({
    credentials = string
    host        = string
    port        = number
  }))
  default     = null
}

variable "kendra_datasource_tags" {
  description = "Tags for Kendra data source"
  type = list(object({
    key   = string
    value = string
  }))
  default     = []
}