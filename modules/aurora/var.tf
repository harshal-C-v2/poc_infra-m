variable "cluster_name" {
  type = string
}
variable "engine_name" {
  type = string
}
variable "engine_version" {
  type = string
}
variable "instance_class" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "vpc_id" {
  type = string
}
variable "db_subnet_group_name" {
  type = string
}
variable "environment" {
  type = string
}
variable "subnets" {
  type = list(string)
}
variable "database_name" {
  type = string
}
variable "master_username" {
  type = string
}