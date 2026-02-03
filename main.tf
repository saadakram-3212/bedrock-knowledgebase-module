module "bedrock" {
  source = "./modules/knowledgebase"  # Adjust path to your module

  # Pass individual values from the object
  create_default_kb                = var.knowledge_base_config.create_default_kb
  kb_name                          = var.knowledge_base_config.kb_name
  kb_description                   = var.knowledge_base_config.kb_description
  kb_role_arn                      = var.knowledge_base_config.kb_role_arn
  kb_tags                          = var.knowledge_base_config.kb_tags
  allow_opensearch_public_access   = var.knowledge_base_config.allow_opensearch_public_access
  number_of_shards                 = var.knowledge_base_config.number_of_shards
  number_of_replicas               = var.knowledge_base_config.number_of_replicas
  vector_dimension                 = var.knowledge_base_config.vector_dimension
  metadata_field                   = var.knowledge_base_config.metadata_field
  text_field                       = var.knowledge_base_config.text_field
  vector_field                     = var.knowledge_base_config.vector_field
  kb_embedding_model_arn           = var.knowledge_base_config.kb_embedding_model_arn
  embedding_model_dimensions       = var.knowledge_base_config.embedding_model_dimensions
  embedding_data_type              = var.knowledge_base_config.embedding_data_type
  create_supplemental_data_storage = var.knowledge_base_config.create_supplemental_data_storage
  supplemental_data_s3_uri         = var.knowledge_base_config.supplemental_data_s3_uri
  permissions_boundary_arn         = var.knowledge_base_config.permissions_boundary_arn
}