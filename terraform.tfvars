knowledge_bases = [
  # ============================================================
  # Knowledge Base #1 (OpenSearch Serverless)
  # ============================================================
  {
    # Knowledge Base Configuration
    create_default_kb = true
    kb_name           = "my-bedrock-kb"
    kb_description    = "My custom knowledge base"
    kb_tags = {
      Environment = "dev"
    }

    # OpenSearch Configuration
    vector_dimension = 1024

    # S3 Data Source Configuration
    create_s3_data_source   = true
    kb_s3_data_source       = "arn:aws:s3:::test-bucket-for-knowledgebase-datasource"
    data_source_description = "S3 bucket data source for knowledge base"
    data_deletion_policy    = "DELETE"
  },

  # ============================================================
  # Knowledge Base #2 (Kendra GenAI with Web Crawler)
  # ============================================================
  {
    create_default_kb = false
    kb_name           = "my-kendra-kb"
    kb_description    = "Knowledge base backed by Amazon Kendra GenAI with Web Crawler"
    kb_tags = {
      Environment = "dev"
    }

    # Enable Kendra
    create_kendra_config     = true
    kendra_index_arn         = null
    kendra_index_name        = "kendra-genai-index"
    kendra_index_edition     = "GEN_AI_ENTERPRISE_EDITION"
    kendra_index_description = "Kendra index with web crawler for AWS documentation"

    # Web Crawler Configuration
    create_web_crawler      = true
    web_crawler_name        = "aws-docs-crawler"
    web_crawler_description = "Crawls AWS Bedrock documentation"

    web_crawler_seed_urls = [
      "https://docs.aws.amazon.com/bedrock/",
      "https://aws.amazon.com/bedrock/"
    ]

    web_crawler_sync_mode         = "FULL_CRAWL"
    web_crawler_crawl_depth       = "2"
    web_crawler_max_links_per_url = "100"
    web_crawler_crawl_subdomain   = true
    web_crawler_honor_robots      = true
  }
]