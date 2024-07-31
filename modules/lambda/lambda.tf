module "lambda_function" {
  source                 = "terraform-aws-modules/lambda/aws"
  version                = "7.2.6"
  function_name          = var.lambda_function_name
  description            = "This function Can connect to DB"
  handler                = "main.main"
  runtime                = "python3.10"
  package_type           = "Zip"
  create_package         = false
  create_role            = false
  lambda_role            = var.lambda_role_arn
  local_existing_package = "./lambda_code.zip"
  timeout                = "60"
  layers = [ module.lambda_layer_s3.lambda_layer_arn ]
  environment_variables = {
    Environment = var.environment
    DB_ENDPOINT_READER = var.DB_ENDPOINT_READER
    DB_ENDPOINT_WRITER = var.DB_ENDPOINT_WRITER
    DB_NAME = var.DB_NAME
    DB_PORT = var.DB_PORT
    SECRET_NAME = var.SECRET_NAME
  }
  vpc_security_group_ids = [var.security_group_id]
  vpc_subnet_ids         = var.vpc_subnet_ids
  tags = {
    Environment = var.env
  }
}



resource "aws_security_group_rule" "secrets_manager" {
  type                     = "ingress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.security_group_id
  security_group_id        = var.security_group_id
}
resource "aws_security_group_rule" "secrets_manageregr" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = var.security_group_id
  security_group_id        = var.security_group_id
}
resource "aws_vpc_endpoint" "secrets_manager" {
  vpc_id             = var.vpc_id
  service_name       = "com.amazonaws.${data.aws_region.current.name}.secretsmanager"
  vpc_endpoint_type  = "Interface"
  security_group_ids = [var.security_group_id]
  subnet_ids         = var.vpc_subnet_ids
  private_dns_enabled = true
}
data "aws_region" "current" {}