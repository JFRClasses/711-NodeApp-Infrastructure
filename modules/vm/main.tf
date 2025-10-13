
# Par de claves
resource "aws_key_pair" "restaurant_keys" {
  key_name = "${var.aws_key_pair_name}-${var.aws_env}"
  public_key = file("./keys/restaurant_key.pub")
}

# Security Groups
  resource "aws_security_group" "restaurant_sg" {
    name     = "${var.aws_sg_name}-${var.aws_env}"
  description = "Permitir acceso a traves de SSH"

  ingress {
    description = "SSH"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Node App"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "Node App"
    from_port = 5432
    to_port = 5432
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Crear EC2
resource "aws_instance" "restaurant_app_instance" {
  ami = "ami-0cfde0ea8edd312d4"
  instance_type = "t3.small"
  vpc_security_group_ids = [ aws_security_group.restaurant_sg.id ]
  key_name = aws_key_pair.restaurant_keys.key_name
  user_data = filebase64("${path.module}/scripts/docker-install.sh")

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = file("./keys/restaurant_key")
    }
    inline = [ 
      "mkdir /home/ubuntu/containers",
      "mkdir /home/ubuntu/.aws",
      "sudo mkdir -p /volumes/nginx/certs",
      "sudo mkdir -p /volumes/nginx/vhostd",
      "sudo mkdir -p /volumes/nginx/html",
      "sudo chmod 777 /volumes/nginx/certs",
      "sudo chmod 777 /volumes/nginx/vhostd",
      "sudo chmod 777 /volumes/nginx/html",
      "touch /home/ubuntu/containers/.env",
      "echo USER_EMAIL=\"${var.node_app_email}\" >> /home/ubuntu/containers/.env",
      "echo SERVICE=\"${var.node_app_service}\" >> /home/ubuntu/containers/.env",
      "echo PASSWORD=\"${var.node_app_password}\" >> /home/ubuntu/containers/.env",
      "echo NODE_APP_IMAGE=\"${var.node_app_image}\" >> /home/ubuntu/containers/.env",
      "echo MAIN_DOMAIN=\"${var.main_domain}\" >> /home/ubuntu/containers/.env",
      "sudo echo \"[default]\naws_access_key_id=${var.aws_access_key}\naws_secret_access_key=${var.aws_secret_key}\" | sudo tee /home/ubuntu/.aws/credentials >/dev/null",
      "sudo echo \"[default]\nregion=${var.aws_region}\noutput=json\" | sudo tee /home/ubuntu/.aws/config >/dev/null",
      "sudo chown -R ubuntu:ubuntu /home/ubuntu/.aws",
      "sudo chmod 700 /home/ubuntu/.aws",
      "sudo chmod 600 /home/ubuntu/.aws/credentials /home/ubuntu/.aws/config",
      
    ]
  }

  provisioner "file" {
    source = "${path.module}/containers/docker-compose.yml"
    destination = "/home/ubuntu/containers/docker-compose.yml"
     connection {
      type = "ssh"
      host = self.public_ip
      user = "ubuntu"
      private_key = file("./keys/restaurant_key")
    }
  }


  tags = {
    Name = "${var.aws_server_name} - ${var.aws_env}"
  }
}

resource "time_sleep" "wait_60_seconds" {
  depends_on = [ aws_instance.restaurant_app_instance ]
  create_duration = "60s"
}

resource "null_resource" "aws_configure" {
  depends_on = [ time_sleep.wait_60_seconds ]
  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = aws_instance.restaurant_app_instance.public_ip
      user = "ubuntu"
      private_key = file("./keys/restaurant_key")
    }
    inline = [ 
      "if ! command -v aws >/dev/null 2>&1; then sudo apt-get update -y && sudo apt-get install -y unzip curl jq && curl -sSL https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip -o awscliv2.zip && unzip -q awscliv2.zip && sudo ./aws/install && rm -rf awscliv2.zip aws; fi",
      "aws --version",
      "aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 970547369328.dkr.ecr.us-east-2.amazonaws.com",
      "cd containers",
      "docker-compose up -d"
     ]
  }
}

# Output

 # State

 # Modules