data "aws_ssm_parameter" "telegram_bot_token" {
  name = var.telegram_bot_token_param
}

data "aws_ssm_parameter" "admin_passwd" {
  name = var.admin_passwd_param
}

data "aws_ssm_parameter" "wallet_passwd" {
  name = var.wallet_passwd_param
}

data "aws_ssm_parameter" "db_passwd" {
  name = var.db_passwd_param
}
