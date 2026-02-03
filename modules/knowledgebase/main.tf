# – OpenSearch Serverless Default –

resource "random_string" "solution_suffix" {
  count   = var.create_default_kb ? 1 : 0
  length  = 4
  special = false
  upper   = false
}

data "aws_caller_identity" "current" {
  count = var.create_default_kb ? 1 : 0
}

data "aws_iam_session_context" "current" {
  count = var.create_default_kb ? 1 : 0
  arn   = data.aws_caller_identity.current[0].arn
}

# Create a Collection
resource "awscc_opensearchserverless_collection" "os_collection" {
  count       = var.create_default_kb ? 1 : 0
  name        = "os-collection-${random_string.solution_suffix[0].result}"
  type        = "VECTORSEARCH"
  description = "OpenSearch collection created by Terraform."
  depends_on = [
    aws_opensearchserverless_security_policy.security_policy,
    aws_opensearchserverless_security_policy.nw_policy
  ]
  tags = var.kb_tags != null ? [for k, v in var.kb_tags : { key = k, value = v }] : []
}

# Encryption Security Policy
resource "aws_opensearchserverless_security_policy" "security_policy" {
  count = var.create_default_kb ? 1 : 0
  name  = "security-policy-${random_string.solution_suffix[0].result}"
  type  = "encryption"
  policy = jsonencode({
    Rules = [
      {
        Resource     = ["collection/os-collection-${random_string.solution_suffix[0].result}"]
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

# Network policy
resource "aws_opensearchserverless_security_policy" "nw_policy" {
  count = var.create_default_kb && var.allow_opensearch_public_access ? 1 : 0
  name  = "nw-policy-${random_string.solution_suffix[0].result}"
  type  = "network"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/os-collection-${random_string.solution_suffix[0].result}"]
        },
      ]
      AllowFromPublic = true,
    },
    {
      Description = "Public access for dashboards",
      Rules = [
        {
          ResourceType = "dashboard"
          Resource = [
            "collection/os-collection-${random_string.solution_suffix[0].result}"
          ]
        }
      ],
      AllowFromPublic = true
    }
  ])
}

# Data policy
resource "aws_opensearchserverless_access_policy" "data_policy" {
  count = var.create_default_kb ? 1 : 0
  name  = "os-access-policy-${random_string.solution_suffix[0].result}"
  type  = "data"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "index"
          Resource = [
            "index/${awscc_opensearchserverless_collection.os_collection[0].name}/*"
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
            "collection/${awscc_opensearchserverless_collection.os_collection[0].name}"
          ]
          Permission = [
            "aoss:DescribeCollectionItems",
            "aoss:DeleteCollectionItems",
            "aoss:CreateCollectionItems",
            "aoss:UpdateCollectionItems"
          ]
        }
      ],
      Principal = distinct(concat(
        [
          data.aws_caller_identity.current[0].arn,
          data.aws_iam_session_context.current[0].issuer_arn
        ],
        [var.kb_role_arn != null ? var.kb_role_arn : aws_iam_role.bedrock_knowledge_base_role.arn]
      ))
    }
  ])
}

# OpenSearch index
resource "time_sleep" "wait_before_index_creation" {
  count           = var.create_default_kb ? 1 : 0
  depends_on      = [aws_opensearchserverless_access_policy.data_policy]
  create_duration = "60s"
}

resource "opensearch_index" "vector_index" {
  count              = var.create_default_kb ? 1 : 0
  name               = "os-vector-index-${random_string.solution_suffix[0].result}"
  number_of_shards   = var.number_of_shards
  number_of_replicas = var.number_of_replicas
  index_knn          = true
  mappings           = <<-EOF
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
  force_destroy      = true
  depends_on         = [time_sleep.wait_before_index_creation, aws_opensearchserverless_access_policy.data_policy]
  lifecycle {
    ignore_changes = [
      number_of_shards,
      number_of_replicas
    ]
  }
}

resource "time_sleep" "wait_after_index_creation" {
  count           = var.create_default_kb ? 1 : 0
  depends_on      = [opensearch_index.vector_index]
  create_duration = "60s"
}

resource "aws_iam_role" "bedrock_knowledge_base_role" {
  name = "AmazonBedrockExecutionRoleForKnowledgeBase-dmv"

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

resource "aws_iam_policy" "bedrock_knowledge_base_policy" {
  count       = var.create_default_kb ? 1 : 0
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
        "Resource" : awscc_opensearchserverless_collection.os_collection[0].arn
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

resource "aws_iam_role_policy_attachment" "bedrock_knowledge_base_policy_attachment" {
  count      = var.create_default_kb ? 1 : 0
  role       = aws_iam_role.bedrock_knowledge_base_role.name
  policy_arn = aws_iam_policy.bedrock_knowledge_base_policy[0].arn
}

resource "awscc_bedrock_knowledge_base" "knowledge_base_default" {
  count       = var.create_default_kb ? 1 : 0
  name        = "${var.kb_name}-dmv"
  description = var.kb_description
  role_arn    = var.kb_role_arn != null ? var.kb_role_arn : aws_iam_role.bedrock_knowledge_base_role.arn
  tags        = var.kb_tags

  storage_configuration = {
    type = "OPENSEARCH_SERVERLESS"
    opensearch_serverless_configuration = {
      collection_arn    = awscc_opensearchserverless_collection.os_collection[0].arn
      vector_index_name = opensearch_index.vector_index[0].name
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