# global
###################################################################################
variable "region" {
  default     = "us-east-1"
  description = "region where the infrastructure resides"
}

variable "availability_zone_a" {
  default     = "us-east-1a"
  description = "availability zone"
}

variable "availability_zone_b" {
  default     = "us-east-1b"
  description = "availability zone"
}

variable "availability_zone_c" {
  default     = "us-east-1c"
  description = "availability zone"
}

# vpn
###################################################################################
variable "wg_server_port" {
  default     = 51821
  description = "Port for the vpn server."
}

variable "wg_server_private_key_param" {
  default     = "/wireguard/wg-server-private-key"
  description = "The SSM parameter containing the WG server private key."
}

variable "wg_server_interface" {
  default     = "eth0"
  description = "The default interface to forward network traffic to."
}

variable "wg_persistent_keepalive" {
  default     = 25
  description = "Persistent Keepalive - useful for helping connection stability over NATs."
}

variable "wg_server_net" {
  default     = "192.168.200.1/24"
  description = "IP range for vpn server - make sure your Client ips are in this range but not the specific ip i.e. not .1"
}

variable "wg_client_public_keys" {
  description = "List of maps of client IPs and public keys."
  default = [
    { "192.168.200.200/32" = "PnPdECHsN/aC/41W78Qo7dsyms453G15lZ7xKkYetig=" },
  ]
}

# db
######################################################################

variable "db_passwd_param" {
  default     = "/db/passwd"
  description = "The SSM parameter containing the DB password."
}

variable "db_username" {
  description = "Database username"
  default     = "chainlink"
}

variable "cpu_utilization_threshold" {
  description = "cpu utilization threshold"
  default     = 80 #percentage
}

variable "freeable_memory_threshold" {
  description = "freeable memory threshold"
  default     = 300000000 #300M
}

variable "free_storage_space_threshold" {
  description = "free storage space threshold"
  default     = 2000000000 #2G
}

variable "disk_queue_depth_threshold" {
  description = "disk queue depth threshold"
  default     = 20
}


# linknode
######################################################################

variable "node_private_ip_1" {
  description = "A private IP address for chainlink node"
  type        = string
  default     = "192.168.11.11"
}

variable "node_private_ip_2" {
  description = "A private IP address for chainlink node"
  type        = string
  default     = "192.168.12.12"
}

variable "chainlink_node_port" {
  description = "open port for chainlink node api"
  type        = string
  default     = "6688"
}

variable "ami" {
  description = "Amazon Machine Image"
  type = string
  default = "ami-042e8287309f5df03"
}

variable "eth_chain_id" {
  description = "eth chain id"
  default     = 4
}

variable "min_outgoing_confirmations" {
  description = "minimum outgoing confirmations"
  default     = 2
}

variable "link_contract_address" {
  description = "chainlink token contract address"
  default     = "0x01BE23585060835E02B77ef475b0Cc51aA1e0709"
}

variable "eth_url" {
  description = <<EOT
  eth client url, it is used in linknode .env file.
  For example, you can use the infura eth client endpoint, it looks something like this

  wss://rinkeby.infura.io/ws/v3/YOUR_PROJECT_ID
  EOT
  #default     = ""
}

variable "admin_email" {
  description = "admin email"
  default     = "user@test.com"
}

variable "admin_passwd_param" {
  default     = "/linknode/admin_passwd"
  description = "The SSM parameter containing the chainlink node admin password(for login)."
}

variable "wallet_passwd_param" {
  default     = "/linknode/wallet_passwd"
  description = "The SSM parameter containing the chainlink node wallet password."
}

# monitor
############################################################################

variable "monitor_private_ip" {
  description = "A private IP address for monitor node"
  type        = string
  default     = "192.168.11.222"
}

variable "telegram_bot_image" {
  type        = string
  description = <<EOT
  telegram bot docker image, the default image is built based on
  latest commit(1719dbbb) of https://github.com/inCaller/prometheus_bot",
  I would strongly recommend you change it to something that
  you control. You really don't want your infrastructure at the mercy of my changes.
  EOT
  default     = "xinba/telegram-bot"
}

variable "telegram_chat_id" {
  type        = string
  description = "telegram chat id, it looks like this: -580333477"
  #default     = ""
}

variable "telegram_bot_token_param" {
  default     = "/monitor/telegram_bot_token"
  description = "telegram bot token"
}

variable "telegram_bot_timezone" {
  default     = "UTC"
  description = "telegram bot timezone"
}

variable "node_exporter_port" {
  description = "node exporter port"
  default     = 9100
}