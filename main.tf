
module "bedrock" {
  source                = "./modules/knowledgebase" 
  create_default_kb     = true
  create_s3_data_source = true
}