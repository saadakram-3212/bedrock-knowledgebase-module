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
  # Knowledge Base #2 (Kendra GenAI)
  # ============================================================
  {
    create_default_kb = false
    kb_name           = "my-kendra-kb"
    kb_description    = "Knowledge base backed by Amazon Kendra GenAI"
    kb_tags = {
      Environment = "dev"
    }

    # Enable Kendra
    create_kendra_config = true
    kendra_index_arn       = null
    kendra_index_name = "kendra-genai-index"
    kendra_index_edition = "GEN_AI_ENTERPRISE_EDITION"

    # Use an existing Kendra index
  }
]
