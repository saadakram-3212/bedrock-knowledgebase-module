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

  # IAM Configuration
  permissions_boundary_arn = each.value.permissions_boundary_arn
}