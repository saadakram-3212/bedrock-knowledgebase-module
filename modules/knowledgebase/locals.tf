locals {
  vector_ingestion_configuration = {
    chunking_configuration = var.chunking_strategy == null ? null : {
      chunking_strategy = var.chunking_strategy
      fixed_size_chunking_configuration = var.chunking_strategy_max_tokens == null ? null : {
        max_tokens         = var.chunking_strategy_max_tokens
        overlap_percentage = var.chunking_strategy_overlap_percentage
      }
      hierarchical_chunking_configuration = var.heirarchical_overlap_tokens == null && var.level_configurations_list == null ? null : {
        level_configurations = var.level_configurations_list
        overlap_tokens       = var.heirarchical_overlap_tokens
      }
      semantic_chunking_configuration = var.breakpoint_percentile_threshold == null && var.semantic_buffer_size == null && var.semantic_max_tokens == null ? null : {
        breakpoint_percentile_threshold = var.breakpoint_percentile_threshold
        buffer_size                     = var.semantic_buffer_size
        max_tokens                      = var.semantic_max_tokens
      }
    }
    context_enrichment_configuration = var.create_context_enrichment_config == false ? null : {
      type = var.context_enrichment_type
      bedrock_foundation_model_configuration = {
        model_arn = var.context_enrichment_model_arn
        enrichment_strategy_configuration = {
          method = var.enrichment_strategy_method
        }
      }
    }
    custom_transformation_configuration = var.create_custom_tranformation_config == false ? null : {
      intermediate_storage = {
        s3_location = {
          uri = var.s3_location_uri
        }
      }
      transformations = var.transformations_list
    }
    parsing_configuration = var.create_parsing_configuration == false ? null : {
      bedrock_foundation_model_configuration = {
        model_arn = var.parsing_config_model_arn
        parsing_prompt = {
          parsing_prompt_text = var.parsing_prompt_text
        }
        parsing_modality = var.parsing_modality
      }
      bedrock_data_automation_configuration = var.create_bedrock_data_automation_config == false ? null : {
        parsing_modality = var.parsing_modality
      }
      parsing_strategy = var.parsing_strategy
    }
  }
}