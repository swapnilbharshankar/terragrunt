module "ec2_instance" {
  source                  = "terraform-aws-modules/ec2-instance/aws"

  name                    = var.name

  instance_type           = "t2.micro"
  key_name                = var.key_name
  monitoring              = false
  associate_public_ip_address = true
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.security_groups

  tags                    = var.tags
  user_data = <<-EOF
#!/bin/bash
sudo yum update -y
sudo yum install -y httpd.x86_64
sudo systemctl start httpd.service
sudo systemctl enable httpd.service
instanceId=$(curl http://169.254.169.254/latest/meta-data/instance-id)
instanceAZ=$(curl http://169.254.169.254/latest/meta-data/placement/availability-zone)
pubHostName=$(curl http://169.254.169.254/latest/meta-data/public-hostname)
pubIPv4=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
privHostName=$(curl http://169.254.169.254/latest/meta-data/local-hostname)
privIPv4=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
echo "<font face = "Verdana" size = "5">"                                       > /var/www/html/index.html
echo "<center><h1>AWS Linux VM Deployed with Terraform</h1></center>"          >> /var/www/html/index.html
echo "<center> <b>EC2 Instance Metadata</b> </center>"                         >> /var/www/html/index.html
echo "<center> <b>Instance ID:</b> $instanceId </center>"                      >> /var/www/html/index.html
echo "<center> <b>AWS Availablity Zone:</b> $instanceAZ </center>"             >> /var/www/html/index.html
echo "<center> <b>Public Hostname:</b> $pubHostName </center>"                 >> /var/www/html/index.html
echo "<center> <b>Public IPv4:</b> $pubIPv4 </center>"                         >> /var/www/html/index.html
echo "<center> <b>Private Hostname:</b> $privHostName </center>"               >> /var/www/html/index.html
echo "<center> <b>Private IPv4:</b> $privIPv4 </center>"                       >> /var/www/html/index.html
echo "</font>"                                                                 >> /var/www/html/index.html
EOF
}
# resource "aws_instance" "ec2_instance" {
#   ami             = var.ami
#   key_name        = var.key_name
#   subnet_id       = var.subnet_id
#   security_groups = var.security_groups


#   instance_type = "t2.micro"


#   tags = {
#     Name = var.name
#   }
# }