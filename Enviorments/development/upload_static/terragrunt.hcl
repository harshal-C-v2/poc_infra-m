terraform {
	source = "../../../modules/upload_static"
}

include "root"{
	path = find_in_parent_folders()
}
// remote_state{
// 	backend = "s3"
// 	generate  = {
// 		bucket         = "random-vieer"
// 		key            = "backend/terraform.tfstate"
// 		region         = "us-east-1"
// 	}
// 	config ={
// 	path = "${path_relative_to_include()}/terraform.tfstate"
// 	}
// }
locals {
	config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
	bucket_name = local.config.locals.bucket_name
}

include "env"{
	path = find_in_parent_folders("config.hcl")
	expose = true
	merge_strategy = "no_merge"
}
dependency "api_gateway" {
  config_path = "../api-gateway"
  skip_outputs = true
}
inputs = {
	bucket_name = local.bucket_name
}
