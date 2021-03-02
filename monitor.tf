data "template_file" "monitor_user_data" {
  template = file("${path.module}/templates/monitoring/monitor-user-data.txt")

  vars = {
    s3_bucket = aws_s3_bucket.chainlink_bucket.bucket

    garfana_datasources_config = data.template_file.garfana_datasources_config.rendered
    garfana_dashboards_config  = data.template_file.garfana_dashboards_config.rendered
    prometheus_config          = data.template_file.prometheus_config.rendered
    alertmanager_config        = data.template_file.alertmanager_config.rendered

    dashboard_app_config_key    = aws_s3_bucket_object.dashboard_app_config.key
    dashboard_server_config_key = aws_s3_bucket_object.dashboard_server_config.key
    app_alert_rules_key         = aws_s3_bucket_object.app_alert_rules.key
    server_alert_rules_key      = aws_s3_bucket_object.server_alert_rules.key

    telegram_bot_image        = var.telegram_bot_image
    telegram_bot_template_key = aws_s3_bucket_object.telegram_bot_template.key
    telegram_bot_config       = data.template_file.telegram_bot_config.rendered
  }
}

data "template_file" "telegram_bot_config" {
  template = file("${path.module}/templates/monitoring/telegram-bot/config.yml")
  vars = {
    telegram_bot_timezone = var.telegram_bot_timezone
    telegram_bot_token    = data.aws_ssm_parameter.telegram_bot_token.value
  }
}

data "template_file" "alertmanager_config" {
  template = file("${path.module}/templates/monitoring/alertmanager/alertmanager.yml")
  vars = {
    telegram_chat_id = var.telegram_chat_id
  }
}

data "template_file" "garfana_datasources_config" {
  template = file("${path.module}/templates/monitoring/grafana/datasources/config.txt")
}

data "template_file" "garfana_dashboards_config" {
  template = file("${path.module}/templates/monitoring/grafana/dashboards/config.txt")
}

data "template_file" "prometheus_config" {
  template = file("${path.module}/templates/monitoring/prometheus/config.txt")
  vars = {
    chainlink_node_private_ip_1 = var.node_private_ip_1
    chainlink_node_private_ip_2 = var.node_private_ip_2
    chainlink_node_port         = var.chainlink_node_port
    node_exporter_port          = var.node_exporter_port
  }
}

resource "aws_iam_instance_profile" "monitor_instance_profile" {
  name = "monitor_instance_profile"
  role = aws_iam_role.monitor_role.name
}

module "ec2" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  instance_count = 1
  name           = "monitoring-node"
  private_ips    = [var.monitor_private_ip]

  associate_public_ip_address = true

  // latest ubuntu 20 ami
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_ids = [
    aws_subnet.ec2_subnet_1.id,
    aws_subnet.ec2_subnet_2.id,
    aws_subnet.ec2_subnet_3.id
  ]
  vpc_security_group_ids = [aws_security_group.chainlink_monitor_sg.id]
  iam_instance_profile   = aws_iam_instance_profile.monitor_instance_profile.name

  user_data_base64 = base64encode(data.template_file.monitor_user_data.rendered)

  ebs_block_device = [{
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = 10
  }]

  key_name = "chainlink"

  tags = {
    "Name" = "monitor"
    "Env"  = "dev"
  }
}

