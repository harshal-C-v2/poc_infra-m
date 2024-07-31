output "DB_ENDPOINT_READER" {
  value = module.cluster.cluster_endpoint
}

output "DB_ENDPOINT_WRITER" {
  value = module.cluster.cluster_endpoint
}

output "DB_NAME" {
  value = module.cluster.cluster_database_name
}

output "DB_PORT" {
  value = module.cluster.cluster_port
}

output "SECRET_NAME" {
  value = module.cluster.cluster_master_user_secret[0]["secret_arn"]
}
output "security_group_id" {
  value = aws_security_group.this.id
}