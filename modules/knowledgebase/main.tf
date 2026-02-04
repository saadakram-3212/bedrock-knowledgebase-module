
resource "time_sleep" "wait_after_index_creation" {
  count           = var.create_default_kb ? 1 : 0
  depends_on      = [opensearch_index.vector_index]
  create_duration = "60s"
}

resource "aws_iam_role" "bedrock_knowledge_base_role" {
  name = "${var.kb_name}-ExecutionRoleForKnowledgeBase"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "bedrock.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      },
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "kendra.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  permissions_boundary = var.permissions_boundary_arn
}

resource "aws_iam_policy" "bedrock_knowledge_base_policy" {
  count       = var.create_default_kb ? 1 : 0
  name        = "${var.kb_name}-Policy"
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
  name        = "${var.kb_name}"
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


resource "awscc_bedrock_data_source" "knowledge_base_ds" {
  count                = var.create_s3_data_source ? 1 : 0
  knowledge_base_id    = var.create_default_kb ? awscc_bedrock_knowledge_base.knowledge_base_default[0].id : null
  name                 = "${var.kb_name}DataSource"
  description          = var.data_source_description
  data_deletion_policy = var.data_deletion_policy
  data_source_configuration = {
    type = "S3"
    s3_configuration = {
      bucket_arn              = var.kb_s3_data_source # Create an S3 bucket or reference existing
    }
  }
  vector_ingestion_configuration       = var.create_vector_ingestion_configuration == false ? null : local.vector_ingestion_configuration
  server_side_encryption_configuration = var.server_side_encryption_configuration
}


### Kendra Bedrock

resource "aws_iam_policy" "bedrock_kb_kendra" {
  count = var.kb_role_arn != null || var.create_kendra_config == false ? 0 : 1
  name  = "AmazonBedrockKnowledgeBaseKendraIndexAccessStatement_${var.kb_name}"

  policy = jsonencode({
    "Version" = "2012-10-17"
    "Statement" = [
      {
        "Action" = [
          "kendra:Retrieve",
          "kendra:DescribeIndex"
        ]
        "Effect"   = "Allow"
        "Resource" = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "bedrock_knowledge_base_kendra_policy_attachment" {
  count      = var.kb_role_arn != null || var.create_kendra_config == false ? 0 : 1
  role       = aws_iam_role.bedrock_knowledge_base_role.name
  policy_arn = aws_iam_policy.bedrock_kb_kendra[0].arn
}



resource "awscc_bedrock_knowledge_base" "knowledge_base_kendra" {
  count       = var.create_kendra_config ? 1 : 0
  name        = "kendra-${var.kb_name}"
  description = var.kb_description
  role_arn    = var.kb_role_arn != null ? var.kb_role_arn : aws_iam_role.bedrock_knowledge_base_role.arn
  tags        = var.kb_tags

  knowledge_base_configuration = {
    type = "KENDRA"
    kendra_knowledge_base_configuration = {
            kendra_index_arn = var.kendra_index_arn    }
  }

}
