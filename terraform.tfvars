knowledge_bases = [
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
  }
]