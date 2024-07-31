terraform {
	source = "../../../modules/s3"
}

include "root"{
	path = find_in_parent_folders()
}

locals {
	config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
	bucket_name = local.config.locals.bucket_name
}

include "env"{
	path = find_in_parent_folders("config.hcl")
	expose = true
	merge_strategy = "no_merge"
}

inputs = {
	bucket = local.bucket_name
}
