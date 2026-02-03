# Create a Collection
resource "awscc_opensearchserverless_collection" "os_collection" {
  count       = var.create_default_kb ? 1 : 0
  name        = "os-collection-${var.kb_name}"
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
  name  = "security-policy-${var.kb_name}"
  type  = "encryption"
  policy = jsonencode({
    Rules = [
      {
        Resource     = ["collection/os-collection-${var.kb_name}"]
        ResourceType = "collection"
      }
    ],
    AWSOwnedKey = true
  })
}

# Network policy
resource "aws_opensearchserverless_security_policy" "nw_policy" {
  count = var.create_default_kb && var.allow_opensearch_public_access ? 1 : 0
  name  = "nw-policy-${var.kb_name}"
  type  = "network"
  policy = jsonencode([
    {
      Rules = [
        {
          ResourceType = "collection"
          Resource     = ["collection/os-collection-${var.kb_name}"]
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
            "collection/os-collection-${var.kb_name}"
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
  name  = "os-access-policy-${var.kb_name}"
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
  name               = "os-vector-index-${var.kb_name}"
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