module "vm-linux-dev" {
  source = "../../modules/vm"
  aws_env = var.AWS_ENV
  aws_server_name = var.AWS_SERVER_NAME
  aws_key_pair_name = var.AWS_KEY_PAIR_NAME
  aws_access_key = var.AWS_ACCESS_KEY
  aws_secret_key = var.AWS_SECRET_KEY
  aws_region = var.AWS_REGION
  aws_sg_name = var.AWS_SG_NAME
  node_app_email = var.NODE_APP_EMAIL
  node_app_password = var.NODE_APP_PASSWORD
  node_app_image = var.NODE_APP_IMAGE
  node_app_service = var.NODE_APP_SERVICE
}

output "aws_ip" {
  value = module.vm-linux-dev.aws_instance_ip
}