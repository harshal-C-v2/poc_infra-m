locals {
	env = "development"
	bucket_name = "v2bahadur-project-vieer"
	
	vpc_id = "vpc-0143108aaac434cf3"
	subnet_id = ["subnet-019f75629d289f583", "subnet-06b0a6fd3ad6d40aa"]

	# Function 
	lambda_function_name = "margisha-development"
	lambda_role_arn = "arn:aws:iam::370180090626:role/admin-role-lambda"

	#Api-gateway Name
	api_gateway_name = "margisha-development"
	
	#Aurora
	instance_type  = "db.t3.medium"
	instance_class = "aurora-postgresql"
	cluster_name         = "margisha"
	engine_name          = "aurora-postgresql"
	engine_version       = "15.4"
	db_subnet_group_name = "margisha"
	database_name = "margisha"
	master_username = "margisha"

	#cloudfront
	home_page = "frontend/home.html"
	
}

// terraform {
//   backend "s3" {
//     bucket         = "my-terraform-state"
//     key            = "frontend-app/terraform.tfstate"
//     region         = "us-east-1"
//     encrypt        = true
//     dynamodb_table = "my-lock-table"
//   }
// }