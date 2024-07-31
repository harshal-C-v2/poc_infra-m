# data "template_file" "index" {
#   template = file("./template/home.html")

#   vars = {
#     url = var.api_url
#   }
# }
# resource "local_file" "generated_index" {
#   filename = "./site/home.html"
#   content  = data.template_file.index.rendered
# }
# variable "api_url" {
#   type = string
# }
variable "source_directory" {
  type    = string
  default = "./site"
}
variable "bucket_name" {
  type = string
}
# resource "aws_s3_bucket_object" "files" {
#   for_each = fileset(var.source_directory, "**/*")
#   bucket = var.bucket_name
#   key    = "site/${each.value}"
#   source = "${var.source_directory}/${each.value}"
#   acl    = "private"
# }
resource "aws_s3_bucket_object" "files" {
  bucket = var.bucket_name
  key    = "frontend/home.html"
  content = file("site/home.html")
  acl    = "private"
  content_type = "test/html"
}
resource "aws_s3_bucket_object" "files" {
  bucket = var.bucket_name
  key    = "frontend/403.html"
  content = file("site/403.html")
  acl    = "private"
  content_type = "test/html"
}