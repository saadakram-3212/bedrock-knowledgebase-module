
module "bedrock" {
  source                = "./modules/knowledgebase" # local example
  create_default_kb     = true
  create_agent          = false
  create_s3_data_source = true
}