variable "lambda_function_name" {
  type = string
}
variable "env" {
  type = string
}
variable "vpc_subnet_ids" {
  type = list(string)
}
variable "vpc_id" {
  type = string
}
variable "lambda_role_arn" {
  type = string
}
variable "environment" {
  type = string
}
variable "DB_ENDPOINT_READER" {
  type = string
}

variable "DB_ENDPOINT_WRITER" {
  type = string
}
variable "DB_PORT" {
  type = string
}
variable "DB_NAME" {
  type = string
}
variable "SECRET_NAME" {
  type = string
}
variable "security_group_id" {
  type = string
}