data "template_file" "linknode_user_data" {
  template = file("${path.module}/templates/linknode/linknode-user-data.txt")

  vars = {
    db_endpoint = module.db.this_db_instance_address
    #db_endpoint                = aws_instance.db.private_ip
    eth_chain_id               = var.eth_chain_id
    min_outgoing_confirmations = var.min_outgoing_confirmations
    link_contract_address      = var.link_contract_address
    eth_url                    = var.eth_url
    db_username                = var.db_username
    db_passwd                  = data.aws_ssm_parameter.db_passwd.value
    admin_email                = var.admin_email
    admin_passwd               = data.aws_ssm_parameter.admin_passwd.value
    wallet_passwd              = data.aws_ssm_parameter.wallet_passwd.value
  }
}

resource "aws_placement_group" "chainlink_nodes" {
  name     = "chainlink_nodes"
  strategy = "spread"
}

module "ec2_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 2.0"

  instance_count              = 2
  name                        = "chainlink-node"
  associate_public_ip_address = true
  private_ips                 = [var.node_private_ip_1, var.node_private_ip_2]

  // latest ubuntu 20 ami from aws
  ami           = var.ami
  instance_type = "t2.micro"
  subnet_ids = [
    aws_subnet.ec2_subnet_1.id,
    aws_subnet.ec2_subnet_2.id,
    aws_subnet.ec2_subnet_3.id
  ]
  vpc_security_group_ids = [aws_security_group.chainlink_node_sg.id]
  placement_group        = aws_placement_group.chainlink_nodes.id

  user_data_base64 = base64encode(data.template_file.linknode_user_data.rendered)

  ebs_block_device = [{
    device_name = "/dev/sdb"
    volume_type = "gp2"
    volume_size = 20
  }]

  key_name = "chainlink"

  tags = {
    "Name" = "linknode"
    "Env"  = "dev"
  }
}
