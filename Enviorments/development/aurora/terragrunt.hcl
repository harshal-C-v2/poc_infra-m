terraform {
	source = "../../../modules/aurora"
}

include "root"{
	path = find_in_parent_folders()
}

locals {
	config = read_terragrunt_config(find_in_parent_folders("config.hcl"))
	env = local.config.locals.env
    subnets = local.config.locals.subnet_id
	instance_type  = local.config.locals.instance_type
	instance_class = local.config.locals.instance_class
	cluster_name         = local.config.locals.cluster_name
	engine_name          = local.config.locals.engine_name
	engine_version       = local.config.locals.engine_version
	db_subnet_group_name = local.config.locals.db_subnet_group_name
	vpc_id        = local.config.locals.vpc_id
	database_name = local.config.locals.database_name
	master_username = local.config.locals.master_username
}

include "env"{
	path = find_in_parent_folders("config.hcl")
	expose = true
	merge_strategy = "no_merge"
}

inputs = {
	environment = local.env
    subnets = local.subnets
    instance_type  = local.instance_type
    instance_class = local.instance_class
    cluster_name         = local.cluster_name
    engine_name          = local.engine_name
    engine_version       = local.engine_version
	instance_type = local.instance_type
    db_subnet_group_name = local.db_subnet_group_name
    vpc_id        = local.vpc_id
    database_name = local.database_name
    master_username = local.master_username
}
