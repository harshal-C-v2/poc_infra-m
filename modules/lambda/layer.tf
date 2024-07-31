module "lambda_layer_s3" {
  source = "terraform-aws-modules/lambda/aws"
  create_layer = true
  layer_name             = "${var.env}-margisha-DB-layer"
  description            = "Db lambda dependencies"
  compatible_runtimes    = ["python3.10"]
  create_package         = false
  local_existing_package = "./layer.zip"
  store_on_s3            = false
}