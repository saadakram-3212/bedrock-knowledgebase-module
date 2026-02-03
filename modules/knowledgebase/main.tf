# – OpenSearch Serverless Default –

module "oss_knowledgebase" {
  count                              = var.create_default_kb ? 1 : 0
  source                             = "aws-ia/opensearch-serverless/aws"
  version                            = "0.0.5"
  allow_public_access_network_policy = var.allow_opensearch_public_access
  number_of_shards                   = var.number_of_shards
  number_of_replicas                 = var.number_of_replicas
  create_vector_index                = true
  collection_tags                    = var.kb_tags != null ? [for k, v in var.kb_tags : { key = k, value = v }] : []
  vector_index_mappings              = <<-EOF
      {
      "properties": {
          "bedrock-knowledge-base-default-vector": {
          "type": "knn_vector",
          "dimension": ${var.vector_dimension},
          "method": {
              "name": "hnsw",
              "engine": "faiss",
              "parameters": {
              "m": 16,
              "ef_construction": 512
              },
              "space_type": "l2"
          }
          },
          "AMAZON_BEDROCK_METADATA": {
          "type": "text",
          "index": "false"
          },
          "AMAZON_BEDROCK_TEXT_CHUNK": {
          "type": "text",
          "index": "true"
          }
      }
      }
  EOF
}

resource "aws_opensearchserverless_access_policy" "updated_data_policy" {
  count = var.create_default_kb ? 1 : 0

  name = "os-access-policy-dmv"## DMV suffix to avoid name conflicts
  type = "data"

  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/${module.oss_knowledgebase[0].opensearch_serverless_collection.name}/*"
          ]
          Permission = [
            "aoss:UpdateIndex",
            "aoss:DeleteIndex",
            "aoss:DescribeIndex",
            "aoss:ReadDocument",
            "aoss:WriteDocument",
            "aoss:CreateIndex"
          ]
        },
        {
          ResourceType = "collection"
          Resource = [
            "collection/${module.oss_knowledgebase[0].opensearch_serverless_collection.name}"
          ]
          Permission = [
            "aoss:DescribeCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:CreateCollectionItems",
            "aoss:UpdateCollectionItems"
          ]
        }
      ],
      Principal = [
        var.kb_role_arn != null ? var.kb_role_arn : aws_iam_role.bedrock_knowledge_base_role.arn
      ]
    }
  ])
}

resource "time_sleep" "wait_after_index_creation" {
  count           = var.create_default_kb ? 1 : 0
  depends_on      = [module.oss_knowledgebase[0].vector_index]
  create_duration = "60s" # Wait for 60 seconds before creating the index
}


resource "aws_iam_role" "bedrock_knowledge_base_role" {
  name  = "AmazonBedrockExecutionRoleForKnowledgeBase-dmv"## DMV suffix to avoid name conflicts

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "bedrock.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  permissions_boundary = var.permissions_boundary_arn
}

## Policy to allow Bedrock to access OpenSearch Serverless

resource "aws_iam_policy" "bedrock_knowledge_base_policy" {
  name        = "AmazonBedrockKnowledgeBasePolicy-dmv"
  description = "Policy for Bedrock Knowledge Base access"
  
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          "aoss:APIAccessAll"
        ],
        "Resource" : module.oss_knowledgebase[0].opensearch_serverless_collection.arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "bedrock:InvokeModel"
        ],
        "Resource" : var.kb_embedding_model_arn
      },
      {
        "Effect" : "Allow",
        "Action" : [
          "bedrock:ListFoundationModels",
          "bedrock:ListCustomModels"
        ],
        "Resource" : "*"
      }
    ]
  })
}

## Policy Attachment

resource "aws_iam_role_policy_attachment" "bedrock_knowledge_base_policy_attachment" {
  role       = aws_iam_role.bedrock_knowledge_base_role.name
  policy_arn = aws_iam_policy.bedrock_knowledge_base_policy.arn
}

#### Knowledge Base Creation

resource "awscc_bedrock_knowledge_base" "knowledge_base_default" {
  count       = var.create_default_kb ? 1 : 0
  name        = "${var.kb_name}-dmv"## DMV suffix to avoid name conflicts
  description = var.kb_description
  role_arn    = var.kb_role_arn != null ? var.kb_role_arn : aws_iam_role.bedrock_knowledge_base_role.arn
  tags        = var.kb_tags

  storage_configuration = {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration = {
      collection_arn    = module.oss_knowledgebase[0].opensearch_serverless_collection.arn
      vector_index_name = module.oss_knowledgebase[0].vector_index.name
      field_mapping = {
        metadata_field = var.metadata_field
        text_field     = var.text_field
        vector_field   = var.vector_field
      }
    }
  }
  knowledge_base_configuration = {
    type = "VECTOR"
    vector_knowledge_base_configuration = {
      embedding_model_arn = var.kb_embedding_model_arn
      embedding_model_configuration = var.embedding_model_dimensions != null ? {
        bedrock_embedding_model_configuration = {
          dimensions          = var.embedding_model_dimensions
          embedding_data_type = var.embedding_data_type
        }
      } : null
      supplemental_data_storage_configuration = var.create_supplemental_data_storage ? {
        supplemental_data_storage_locations = [
          {
            supplemental_data_storage_location_type = "S3"
            s3_location = {
              uri = var.supplemental_data_s3_uri
            }
          }
        ]
      } : null
    }
  }
  depends_on = [time_sleep.wait_after_index_creation]
}
