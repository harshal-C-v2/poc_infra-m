terraform {
	source = "../../../modules/lambda"
}

include "root"{
	path = find_in_parent_folders()
}

locals {
	config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
	env = local.config.locals.env
	lambda_name = local.config.locals.lambda_function_name
	vpc_id = local.config.locals.vpc_id
	subnet_id = local.config.locals.subnet_id
	lambda_role_arn = local.config.locals.lambda_role_arn
}

include "env"{
	path = find_in_parent_folders("config.hcl")
	expose = true
	merge_strategy = "no_merge"
}
dependency "db" {
  config_path = "../aurora"
  mock_outputs = {
	DB_ENDPOINT_READER = "non"
	DB_ENDPOINT_WRITER = "non"
	DB_NAME = "non"
	DB_PORT = "non"
	SECRET_NAME = "non"
	security_group_id = "non"
  }
}
inputs = {
	lambda_function_name = local.lambda_name
	environment = local.env
	env = local.env
	vpc_subnet_ids = local.subnet_id
	vpc_id =  local.vpc_id
	lambda_role_arn = local.lambda_role_arn
	DB_ENDPOINT_READER = dependency.db.outputs.DB_ENDPOINT_READER
	DB_ENDPOINT_WRITER = dependency.db.outputs.DB_ENDPOINT_WRITER
	DB_NAME = dependency.db.outputs.DB_NAME
	DB_PORT = dependency.db.outputs.DB_PORT
	SECRET_NAME = dependency.db.outputs.SECRET_NAME
	security_group_id = dependency.db.outputs.security_group_id
}
