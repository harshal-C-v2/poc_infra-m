variable "bucket_name" {
  type = string
}
variable "enviorment" {
  type = string
}
variable "home_page" {
  type    = string
  default = "frontend/index.html"
}
variable "api_id" {
  type = string

}
variable "api_key" {
  type = string
  sensitive = true
}