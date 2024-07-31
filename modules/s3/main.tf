module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"
  version = "4.1.2"
  bucket = var.bucket
  acl    = "private"

  control_object_ownership = true
  object_ownership         = "BucketOwnerPreferred"

  versioning = {
    enabled = false
  }
  
  server_side_encryption_configuration = {
    rule = {
      apply_server_side_encryption_by_default = {
        sse_algorithm = "AES256"
      }
    }
  }
  lifecycle_rule = {
    transition = {
      id            = "transition"
      enabled       = true
      days          = 30
      storage_class = "GLACIER"
      transition = {
        days          = 30
        storage_class = "GLACIER"
      }
    }

    noncurrent_version_transition = {
      id              = "noncurrent_version_transition"
      enabled         = true
      noncurrent_days = 60
      storage_class   = "GLACIER"
      transition = {
        days          = 60
        storage_class = "GLACIER"
      }
    }

    expiration = {
      id      = "expiration"
      enabled = true
      expiration = {
        days = 365
      }
    }
  }
  attach_policy = false
  tags = {
    Name = var.bucket
  }
}



variable "bucket" {
  type = string
}