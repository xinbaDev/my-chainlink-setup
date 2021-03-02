module "db" {
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 2.0"

  identifier = "chainlink-db"

  name     = "chainlinkdb"
  port     = "5432"
  username = var.db_username
  password = data.aws_ssm_parameter.db_passwd.value

  engine         = "postgres"
  engine_version = "12.4"
  instance_class = "db.t3.micro"

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  // storage autoscaling
  allocated_storage     = 5
  max_allocated_storage = 100

  // DB parameter group
  family = "postgres12"

  // DB option group
  major_engine_version = "12"

  // mutiple availability zones for auto failover
  multi_az   = true
  subnet_ids = [aws_subnet.db_subnet1.id, aws_subnet.db_subnet2.id]

  // security
  vpc_security_group_ids = [aws_security_group.chainlink_db_sg.id]
  storage_encrypted      = true
  // deletion_protection = true

  // monitoring
  performance_insights_enabled = true
  monitoring_interval          = 60
  monitoring_role_name         = "chainlink_db_monitor_2"
  create_monitoring_role       = true

  tags = {
    "Env" = "prod"
  }
}