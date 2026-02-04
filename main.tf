# ============================================================
# Data Sources
# ============================================================
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "aws_iam_role" "WebCrawlerRole" {
  name = "kendra-web-crawler-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })


  
}

# ============================================================
# Shared IAM Role for ALL Kendra Indexes
# ============================================================
resource "aws_iam_role" "kendra_index_role" {
  name = "kendra-genai-index-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "kendra.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role_policy" "kendra_basic_logging" {
  name = "kendra-basic-logging"
  role = aws_iam_role.kendra_index_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "*"
      }
    ]
  })
}



# ============================================================
# Kendra Module
# Only created for KBs where create_kendra_config = true
# ============================================================
module "kendra" {
  source = "./modules/kendra"

  for_each = {
    for idx, kb in var.knowledge_bases :
    idx => kb
    if kb.create_kendra_config == true
  }

  # Core toggle
  create_kendra_config = each.value.create_kendra_config

  # Existing index support
  kendra_index_arn = each.value.kendra_index_arn

  # Index creation settings
  kendra_index_name        = each.value.kendra_index_name
  kendra_index_edition     = each.value.kendra_index_edition
  kendra_index_description = each.value.kendra_index_description

  kendra_index_query_capacity   = each.value.kendra_index_query_capacity
  kendra_index_storage_capacity = each.value.kendra_index_storage_capacity

  # Optional configs
  kendra_index_tags                = each.value.kendra_index_tags
  user_token_configurations        = each.value.user_token_configurations
  kendra_kms_key_id                = each.value.kendra_kms_key_id
  kendra_index_user_context_policy = each.value.kendra_index_user_context_policy
  document_metadata_configurations = each.value.document_metadata_configurations

  # Shared IAM role for any created index
  kendra_index_role_arn = aws_iam_role.kendra_index_role.arn

  # Web Crawler V2 Configuration
  create_web_crawler            = each.value.create_web_crawler
  web_crawler_name              = each.value.web_crawler_name
  web_crawler_description       = each.value.web_crawler_description
  web_crawler_role_arn          = aws_iam_role.WebCrawlerRole.arn
  web_crawler_seed_urls         = each.value.web_crawler_seed_urls
  web_crawler_sync_mode         = each.value.web_crawler_sync_mode
  web_crawler_field_mappings    = each.value.web_crawler_field_mappings
  web_crawler_crawl_depth       = each.value.web_crawler_crawl_depth
  web_crawler_max_links_per_url = each.value.web_crawler_max_links_per_url
  web_crawler_max_file_size     = each.value.web_crawler_max_file_size
  web_crawler_rate_limit        = each.value.web_crawler_rate_limit
  web_crawler_crawl_subdomain   = each.value.web_crawler_crawl_subdomain
  web_crawler_crawl_all_domain  = each.value.web_crawler_crawl_all_domain
  web_crawler_honor_robots      = each.value.web_crawler_honor_robots
  web_crawler_crawl_attachments = each.value.web_crawler_crawl_attachments
  web_crawler_schedule          = each.value.web_crawler_schedule
  web_crawler_language_code     = each.value.web_crawler_language_code
  web_crawler_tags              = each.value.web_crawler_tags
}

# ============================================================
# Bedrock Knowledge Base Module
# ============================================================
module "bedrock" {
  source   = "./modules/knowledgebase"
  for_each = { for idx, kb in var.knowledge_bases : idx => kb }

  # Knowledge Base Configuration
  create_default_kb = each.value.create_default_kb
  kb_name           = each.value.kb_name
  kb_description    = each.value.kb_description
  kb_role_arn       = each.value.kb_role_arn
  kb_tags           = each.value.kb_tags

  # OpenSearch Serverless Configuration
  allow_opensearch_public_access = each.value.allow_opensearch_public_access
  number_of_shards               = each.value.number_of_shards
  number_of_replicas             = each.value.number_of_replicas
  vector_dimension               = each.value.vector_dimension

  # Knowledge Base Storage Configuration
  metadata_field = each.value.metadata_field
  text_field     = each.value.text_field
  vector_field   = each.value.vector_field

  # Knowledge Base Embedding Configuration
  kb_embedding_model_arn     = each.value.kb_embedding_model_arn
  embedding_model_dimensions = each.value.embedding_model_dimensions
  embedding_data_type        = each.value.embedding_data_type

  # Supplemental Data Storage Configuration
  create_supplemental_data_storage = each.value.create_supplemental_data_storage
  supplemental_data_s3_uri         = each.value.supplemental_data_s3_uri

  # Data Source Configuration
  create_s3_data_source   = each.value.create_s3_data_source
  data_source_description = each.value.data_source_description
  data_deletion_policy    = each.value.data_deletion_policy
  kb_s3_data_source       = each.value.kb_s3_data_source

  # Vector Ingestion Configuration
  create_vector_ingestion_configuration = each.value.create_vector_ingestion_configuration
  create_custom_tranformation_config    = each.value.create_custom_tranformation_config
  create_parsing_configuration          = each.value.create_parsing_configuration

  # Chunking Strategy Configuration
  chunking_strategy                    = each.value.chunking_strategy
  chunking_strategy_max_tokens         = each.value.chunking_strategy_max_tokens
  chunking_strategy_overlap_percentage = each.value.chunking_strategy_overlap_percentage

  # Hierarchical Chunking Configuration
  level_configurations_list   = each.value.level_configurations_list
  heirarchical_overlap_tokens = each.value.heirarchical_overlap_tokens

  # Semantic Chunking Configuration
  breakpoint_percentile_threshold = each.value.breakpoint_percentile_threshold
  semantic_buffer_size            = each.value.semantic_buffer_size
  semantic_max_tokens             = each.value.semantic_max_tokens

  # Custom Transformation Configuration
  s3_location_uri      = each.value.s3_location_uri
  transformations_list = each.value.transformations_list

  # Parsing Configuration
  parsing_config_model_arn = each.value.parsing_config_model_arn
  parsing_prompt_text      = each.value.parsing_prompt_text
  parsing_strategy         = each.value.parsing_strategy

  # Context Enrichment Configuration
  create_context_enrichment_config = each.value.create_context_enrichment_config
  context_enrichment_type          = each.value.context_enrichment_type
  context_enrichment_model_arn     = each.value.context_enrichment_model_arn
  enrichment_strategy_method       = each.value.enrichment_strategy_method

  # Bedrock Data Automation Configuration
  create_bedrock_data_automation_config = each.value.create_bedrock_data_automation_config
  parsing_modality                      = each.value.parsing_modality

  # IAM Configuration
  permissions_boundary_arn = each.value.permissions_boundary_arn

  # Kendra toggle
  create_kendra_config = each.value.create_kendra_config

  # If Kendra is enabled for this KB, pull the ARN from the matching kendra module instance
  kendra_index_arn = (
    each.value.create_kendra_config == true
    ? module.kendra[each.key].kendra_index_arn
    : null
  )

  #Web Crawler Configuration
#   create_web_crawler = each.value.create_web_crawler
#   rate_limit        = each.value.rate_limit
#   max_pages         = each.value.max_pages
#   exclusion_filters = each.value.exclusion_filters
#   inclusion_filters = each.value.inclusion_filters
#   crawler_scope    = each.value.crawler_scope
#   user_agent       = each.value.user_agent
#   seed_urls        = each.value.seed_urls

}