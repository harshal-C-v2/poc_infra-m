terraform {
	source = "../../../modules/api-gateway"
}

include "root"{
	path = find_in_parent_folders()
}

locals {
	config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
	env = local.config.locals.env
	lambda_name = local.config.locals.lambda_function_name

	api_gateway_name = local.config.locals.api_gateway_name
}
dependency "lambda" {
  config_path = "../lambda"
  skip_outputs = true
}

include "env"{
	path = find_in_parent_folders("config.hcl")
	expose = true
	merge_strategy = "no_merge"
}

inputs = {
	lambda_function_name = local.lambda_name
	environment = local.env
	name = local.api_gateway_name
}
