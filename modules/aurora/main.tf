module "cluster" {
  source         = "terraform-aws-modules/rds-aurora/aws"
  version        = "9.3.1"
  name           = var.cluster_name
  engine         = var.engine_name
  engine_version = var.engine_version
  instance_class = var.instance_class
  instances = {
    1 = {
      instance_class = var.instance_type
    }
  }
  publicly_accessible    = false
  vpc_id                 = var.vpc_id
  db_subnet_group_name   = var.db_subnet_group_name
  subnets                = var.subnets
  create_db_subnet_group = true
  
  security_group_rules = {
    ex1_ingress = {
      source_security_group_id = aws_security_group.this.id
    }
  }
  database_name = var.database_name
  master_username = var.master_username
  storage_encrypted                                      = true
  apply_immediately                                      = true
  monitoring_interval                                    = 10
  manage_master_user_password                            = true
  manage_master_user_password_rotation                   = true
  master_user_password_rotation_automatically_after_days = 1
  master_user_password_rotate_immediately = true
  tags = {
    Environment = var.environment
  }
}
resource "aws_security_group" "this" {
  name        = "${var.environment}-db-sg"
  description = "security group"
  vpc_id      = var.vpc_id
  
  tags = {
    Name = "${var.environment}-db-sg"
  }
  
  ingress {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      security_groups = [module.cluster.security_group_id]
    }
  egress  {
      from_port = 0
      to_port   = 0
      protocol  = "-1"
      security_groups = [module.cluster.security_group_id]
    }
  }

output "sg_of_db" {
  value = module.cluster.security_group_id
}
resource "aws_security_group_rule" "outbound" {
  type                     = "egress"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  source_security_group_id = module.cluster.security_group_id
  security_group_id        = module.cluster.security_group_id
}