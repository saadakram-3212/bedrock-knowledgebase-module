# Kendra Index
resource "awscc_kendra_index" "genai_kendra_index" {
  count       = var.create_kendra_config && var.kendra_index_arn == null ? 1 : 0
  edition     = var.kendra_index_edition
  name        = "${var.kendra_index_name}"
  role_arn    = var.kendra_index_role_arn
  description = var.kendra_index_description
  capacity_units = {
    query_capacity_units   = var.kendra_index_query_capacity
    storage_capacity_units = var.kendra_index_storage_capacity
  }
  document_metadata_configurations = var.document_metadata_configurations
  server_side_encryption_configuration = var.kendra_kms_key_id != null ? {
    kms_key_id = var.kendra_kms_key_id
  } : null
  user_context_policy       = var.kendra_index_user_context_policy
  user_token_configurations = var.user_token_configurations
  tags                      = var.kendra_index_tags
}

resource "time_sleep" "wait_after_kendra_index_creation" {
  count           = var.create_kendra_config && var.kendra_index_arn == null ? 1 : 0
  depends_on      = [awscc_kendra_index.genai_kendra_index[0]]
  create_duration = "60s" # Wait for 60 seconds
}


# # Create Kendra Data Source
# resource "awscc_kendra_data_source" "kendra_s3_data_source" {
#   count         = var.create_kendra_s3_data_source == true ? 1 : 0
#   index_id      = var.kendra_index_arn != null ? var.kendra_index_arn : awscc_kendra_index.genai_kendra_index[0].id
#   name          = "${var.kendra_data_source_name}"
#   type          = "S3"
#   role_arn      = awscc_iam_role.kendra_s3_datasource_role[0].arn
#   language_code = var.kendra_data_source_language_code
#   schedule      = var.kendra_data_source_schedule
#   description   = var.kendra_data_source_description
#   tags          = var.kendra_data_source_tags
#   data_source_configuration = {
#     s3_configuration = {
#       bucket_name        = var.s3_data_source_bucket_name != null ? var.s3_data_source_bucket_name : awscc_s3_bucket.s3_data_source[0].bucket_name
#       exclusion_patterns = var.s3_data_source_exclusion_patterns
#       inclusion_patterns = var.s3_data_source_inclusion_patterns
#       documents_metadata_configuration = {
#         s3_prefix = var.s3_data_source_document_metadata_prefix
#       }
#       access_control_list_documents = {
#         key_path = var.s3_data_source_key_path
#       }
#     }
#   }
# }

# resource "time_sleep" "wait_after_kendra_s3_data_source_creation" {
#   count           = var.create_kendra_s3_data_source ? 1 : 0
#   depends_on      = [awscc_kendra_data_source.kendra_s3_data_source[0]]
#   create_duration = "60s" # Wait for 60 seconds
# }

resource "awscc_kendra_data_source" "kendra_web_crawler" {
  count        = var.create_kendra_web_crawler ? 1 : 0
  index_id     = var.kendra_index_arn != null ? split("/", var.kendra_index_arn)[1] : awscc_kendra_index.genai_kendra_index[0].id
  name         = "${var.kendra_index_name}-KendraWebCrawler"
  type         = "WEBCRAWLER"
  description  = var.kendra_web_crawler_description
  role_arn     = var.kendra_datasource_role_arn
  schedule     = var.kendra_web_crawler_schedule # e.g., "cron(0 12 * * ? *)"

  data_source_configuration = {
    web_crawler_configuration = {
      urls = {
        seed_url_configuration = {
          seed_urls         = var.seed_urls
          web_crawler_mode  = var.web_crawler_mode # "HOST_ONLY" or "SUBDOMAINS" or "EVERYTHING"
        }
        site_maps_configuration = var.site_maps != null ? {
          site_maps = var.site_maps
        } : null
      }
      crawl_depth                         = var.crawl_depth # e.g., 2
      max_links_per_page                  = var.max_links_per_page # e.g., 100
      max_content_size_per_page_in_mega_bytes = var.max_content_size_per_page # e.g., 50
      max_urls_per_minute_crawl_rate      = var.max_urls_per_minute # e.g., 300
      url_inclusion_patterns              = var.url_inclusion_patterns
      url_exclusion_patterns              = var.url_exclusion_patterns
      
      proxy_configuration = var.proxy_host != null ? {
        host        = var.proxy_host
        port        = var.proxy_port
        credentials = var.proxy_credentials_secret_arn
      } : null

      authentication_configuration = var.basic_auth_configs != null ? {
        basic_authentication = var.basic_auth_configs
      } : null
    }
  }

  tags = var.kendra_datasource_tags
}