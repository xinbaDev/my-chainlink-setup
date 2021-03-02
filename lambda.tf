resource "aws_lambda_function" "telegram_bot_alarm" {
  filename      = "${path.module}/src/lambda/telegram_bot_alarm.zip"
  function_name = "telegram_bot_alarm"

  handler = "telegram_bot_alarm.lambda_handler"
  runtime = "python3.8"

  role = aws_iam_role.lambda_role.arn

  // use to trigger update
  source_code_hash = filebase64sha256("${path.module}/src/lambda/telegram_bot_alarm.zip")

  environment {
    variables = {
      TOKEN   = data.aws_ssm_parameter.telegram_bot_token.value
      CHAT_ID = var.telegram_chat_id
    }
  }

  tags = {
    "Name"    = "telegram_bot_alarm"
    "Project" = "chainlink"
  }
}

resource "aws_lambda_permission" "sns" {
  statement_id  = "AllowSNSInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.telegram_bot_alarm.function_name
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.rds_alerts.arn
}