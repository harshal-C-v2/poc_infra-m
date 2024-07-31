output "api_gateway_url" {
  value = "${aws_api_gateway_deployment.deployment.invoke_url}${aws_api_gateway_stage.associate_logs.stage_name}/"
}
output "api_key" {
  value = aws_api_gateway_api_key.key.value
  sensitive = true
}
output "api_id" {
  value = aws_api_gateway_rest_api.rest_api.id
}