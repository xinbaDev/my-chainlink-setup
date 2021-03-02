data "aws_ssm_parameter" "wg_server_private_key" {
  name = var.wg_server_private_key_param
}

data "template_file" "vpn_user_data" {
  template = file("${path.module}/templates/vpn/vpn-user-data.txt")

  vars = {
    wg_server_private_key = data.aws_ssm_parameter.wg_server_private_key.value
    wg_server_net         = var.wg_server_net
    wg_server_port        = var.wg_server_port
    peers                 = join("\n", data.template_file.wg_client_data_json.*.rendered)
    wg_server_interface   = var.wg_server_interface
  }
}

data "template_file" "wg_client_data_json" {
  template = file("${path.module}/templates/vpn/client-data.tpl")
  count    = length(var.wg_client_public_keys)

  vars = {
    client_pub_key       = element(values(var.wg_client_public_keys[count.index]), 0)
    client_ip            = element(keys(var.wg_client_public_keys[count.index]), 0)
    persistent_keepalive = var.wg_persistent_keepalive
  }
}

resource "aws_eip" "vpn_ip" {
  instance = aws_instance.wg_vpn.id
  vpc      = true
}

resource "aws_instance" "wg_vpn" {
  // latest ubuntu 20 ami
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.ec2_subnet_1.id

  vpc_security_group_ids = [aws_security_group.chainlink_vpn_sg.id]

  user_data_base64 = base64encode(data.template_file.vpn_user_data.rendered)

  key_name = "chainlink"

  tags = {
    "Name" = "wireguard-vpn"
    "Env"  = "dev"
  }
}
