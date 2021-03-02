locals {
  dashboard_app_config_path    = "${path.module}/templates/monitoring/grafana/dashboards/linknode/app.json"
  dashboard_server_config_path = "${path.module}/templates/monitoring/grafana/dashboards/linknode/server.json"
  app_alert_rules              = "${path.module}/templates/monitoring/prometheus/app_rules.yml"
  server_alert_rules           = "${path.module}/templates/monitoring/prometheus/server_rules.yml"
  telegram_bot_template        = "${path.module}/templates/monitoring/telegram-bot/template.tmpl"
}

resource "aws_s3_bucket" "chainlink_bucket" {
  bucket_prefix = "chainlink-"
  acl           = "private"

  tags = {
    Name = "My chainlink bucket"
    Env  = "dev"
  }
}

resource "aws_s3_bucket_object" "dashboard_app_config" {
  bucket = aws_s3_bucket.chainlink_bucket.bucket
  key    = "dashboard/app.json"
  source = local.dashboard_app_config_path

  etag = filemd5(local.dashboard_app_config_path)
}

resource "aws_s3_bucket_object" "dashboard_server_config" {
  bucket = aws_s3_bucket.chainlink_bucket.bucket
  key    = "dashboard/server.json"
  source = local.dashboard_server_config_path

  etag = filemd5(local.dashboard_server_config_path)
}

resource "aws_s3_bucket_object" "app_alert_rules" {
  bucket = aws_s3_bucket.chainlink_bucket.bucket
  key    = "alert/app_rules.yml"
  source = local.app_alert_rules

  etag = filemd5(local.app_alert_rules)
}

resource "aws_s3_bucket_object" "server_alert_rules" {
  bucket = aws_s3_bucket.chainlink_bucket.bucket
  key    = "alert/server_rules.yml"
  source = local.server_alert_rules

  etag = filemd5(local.server_alert_rules)
}

resource "aws_s3_bucket_object" "telegram_bot_template" {
  bucket = aws_s3_bucket.chainlink_bucket.bucket
  key    = "alert/template.tmpl"
  source = local.telegram_bot_template

  etag = filemd5(local.telegram_bot_template)
}