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

// ...existing code...


// ...existing code...


variable "create_web_crawler" {
  description = "Whether or not to create a Kendra Web Crawler v2 data source."
  type        = bool
  default     = false
}

variable "web_crawler_name" {
  description = "The name of the Web Crawler data source."
  type        = string
  default     = "web-crawler-v2"
}

variable "web_crawler_description" {
  description = "A description for the Web Crawler data source."
  type        = string
  default     = null
}

variable "web_crawler_role_arn" {
  description = "The ARN of the IAM role for the Web Crawler data source."
  type        = string
  default     = null
}

variable "web_crawler_seed_urls" {
  description = "List of seed URLs to crawl."
  type        = list(string)
  default     = ["https://docs.aws.amazon.com/bedrock/"]
}

variable "web_crawler_sync_mode" {
  description = "The sync mode for the web crawler. Valid values: FULL_CRAWL, FORCED_FULL_CRAWL."
  type        = string
  default     = "FULL_CRAWL"
}

variable "web_crawler_field_mappings" {
  description = "Field mappings for web page content."
  type        = list(any)
  default     = []
}

variable "web_crawler_crawl_depth" {
  description = "The number of levels from the seed URL to crawl."
  type        = string
  default     = "2"
}

variable "web_crawler_max_links_per_url" {
  description = "The maximum number of URLs on a web page to include when crawling."
  type        = string
  default     = "100"
}

variable "web_crawler_max_file_size" {
  description = "The maximum size (in MB) of a web page or attachment to crawl."
  type        = string
  default     = "50"
}

variable "web_crawler_rate_limit" {
  description = "The maximum number of URLs crawled per website host per minute."
  type        = string
  default     = "300"
}

variable "web_crawler_crawl_subdomain" {
  description = "Whether to crawl subdomains."
  type        = bool
  default     = true
}

variable "web_crawler_crawl_all_domain" {
  description = "Whether to crawl all domains that the web pages link to."
  type        = bool
  default     = false
}

variable "web_crawler_honor_robots" {
  description = "Whether to respect robots.txt directives."
  type        = bool
  default     = true
}

variable "web_crawler_crawl_attachments" {
  description = "Whether to crawl files that the web pages link to."
  type        = bool
  default     = false
}

variable "web_crawler_schedule" {
  description = "The schedule for Amazon Kendra to update the web crawler index."
  type        = string
  default     = null
}

variable "web_crawler_language_code" {
  description = "The language code for the web crawler data source."
  type        = string
  default     = "en"
}

variable "web_crawler_tags" {
  description = "A map of tags for the web crawler data source."
  type        = map(string)
  default     = null
}

# ==============================================================