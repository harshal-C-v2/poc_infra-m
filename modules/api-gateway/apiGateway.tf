resource "aws_api_gateway_rest_api" "rest_api" {
  name               = var.name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

resource "aws_api_gateway_api_key" "key" {
  name    = aws_api_gateway_rest_api.rest_api.name
  enabled = true
}

resource "aws_api_gateway_usage_plan" "usage-plan" {
  name = "usage-${aws_api_gateway_rest_api.rest_api.name}"
  quota_settings {
    limit  = 1000
    offset = 0
    period = "DAY"
  }
  throttle_settings {
    burst_limit = 100
    rate_limit  = 100
  }
  api_stages {
    api_id = aws_api_gateway_rest_api.rest_api.id
    stage  = aws_api_gateway_stage.associate_logs.stage_name
    # throttle {
    #   burst_limit = 1
    #   rate_limit  = 1
    #   # path        = "/${aws_api_gateway_resource.resource.path_part}/POST"
    #   path = "/"
    # }
  }
}
resource "aws_api_gateway_usage_plan_key" "usage-key" {
  usage_plan_id = aws_api_gateway_usage_plan.usage-plan.id
  key_type      = "API_KEY"
  key_id        = aws_api_gateway_api_key.key.id
}
resource "aws_api_gateway_resource" "resource" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  parent_id   = aws_api_gateway_rest_api.rest_api.root_resource_id
  path_part   = "deployment"
}
resource "aws_api_gateway_method" "method" {
  rest_api_id      = aws_api_gateway_rest_api.rest_api.id
  resource_id      = aws_api_gateway_resource.resource.id
  http_method      = "POST"
  authorization    = "NONE"
  api_key_required = true
}
resource "aws_api_gateway_integration" "integration" {
  rest_api_id             = aws_api_gateway_rest_api.rest_api.id
  resource_id             = aws_api_gateway_resource.resource.id
  http_method             = aws_api_gateway_method.method.http_method
  integration_http_method = "POST"
  type                    = "AWS"
  uri                     = data.aws_lambda_function.lambda_function.invoke_arn
  passthrough_behavior    = "WHEN_NO_TEMPLATES"
}
resource "aws_api_gateway_integration_response" "intigration_response" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = aws_api_gateway_method_response.response-code.status_code
  response_templates = {
    "application/json" = <<EOF
 EOF
  }
}
resource "aws_api_gateway_deployment" "deployment" {
  depends_on  = [aws_api_gateway_integration.integration]
  rest_api_id = aws_api_gateway_rest_api.rest_api.id

}

resource "aws_api_gateway_stage" "associate_logs" {
  stage_name    = "prod"
  rest_api_id   = aws_api_gateway_rest_api.rest_api.id
  deployment_id = aws_api_gateway_deployment.deployment.id

}

resource "aws_api_gateway_method_response" "response-code" {
  rest_api_id = aws_api_gateway_rest_api.rest_api.id
  resource_id = aws_api_gateway_resource.resource.id
  http_method = aws_api_gateway_method.method.http_method
  status_code = "200"
  response_models = {
    "application/json" = "Empty"
  }
}