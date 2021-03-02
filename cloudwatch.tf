resource "aws_cloudwatch_metric_alarm" "cpu_utilization_too_high" {
  alarm_name          = "cpu_utilization_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.cpu_utilization_threshold
  alarm_description   = "Average database CPU utilization over last 10 minutes too high"
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
  ok_actions          = [aws_sns_topic.rds_alerts.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.this_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "disk_queue_depth_too_high" {
  alarm_name          = "disk_queue_depth_too_high"
  comparison_operator = "GreaterThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "DiskQueueDepth"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.disk_queue_depth_threshold
  alarm_description   = "Average database disk queue depth over last 10 minutes too high"
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
  ok_actions          = [aws_sns_topic.rds_alerts.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.this_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "freeable_memory_too_low" {
  alarm_name          = "freeable_memory_too_low"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeableMemory"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.freeable_memory_threshold
  alarm_description   = "Average database freeable memory over last 10 minutes too low"
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
  ok_actions          = [aws_sns_topic.rds_alerts.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.this_db_instance_id
  }
}

resource "aws_cloudwatch_metric_alarm" "free_storage_space_too_low" {
  alarm_name          = "free_storage_space_threshold"
  comparison_operator = "LessThanThreshold"
  evaluation_periods  = "1"
  metric_name         = "FreeStorageSpace"
  namespace           = "AWS/RDS"
  period              = "600"
  statistic           = "Average"
  threshold           = var.free_storage_space_threshold
  alarm_description   = "Average database free storage space over last 10 minutes too low"
  alarm_actions       = [aws_sns_topic.rds_alerts.arn]
  ok_actions          = [aws_sns_topic.rds_alerts.arn]

  dimensions = {
    DBInstanceIdentifier = module.db.this_db_instance_id
  }
}