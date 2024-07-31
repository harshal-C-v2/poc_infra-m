terraform {
	source = "../../../modules/cloudfront"
}

include "root"{
	path = find_in_parent_folders()
}
dependency "apigateway" {
  config_path = "../api-gateway"
  mock_outputs = {
    api_id = "null"
	api_key = "null"	
  }
}

locals {
	config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
	bucket_name = local.config.locals.bucket_name
	enviorment = local.config.locals.env
	home_page = local.config.locals.home_page
}

include "env"{
	path = find_in_parent_folders("config.hcl")
	expose = true
	merge_strategy = "no_merge"
}

inputs = {
	bucket_name = local.bucket_name
	enviorment = local.enviorment
	home_page = local.home_page
	api_id = dependency.apigateway.outputs.api_id
	api_key = dependency.apigateway.outputs.api_key
}
