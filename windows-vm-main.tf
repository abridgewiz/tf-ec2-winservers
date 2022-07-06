###################################
## Virtual Machine Module - Main ##
###################################

# Bootstrapping PowerShell Script
data "template_file" "windows-userdata" {
  template = <<EOF
<powershell>
# Rename Machine
Rename-Computer -NewName "${var.windows_instance_name}" -Force;

# Install IIS
Install-WindowsFeature -name Web-Server -IncludeManagementTools;

Open Port 80 Firewall
netsh advfirewall firewall add rule name="HTTP 80" protocol=TCP dir=in localport=80 action=allow;

# Restart machine
shutdown -r -t 10;
</powershell>
EOF
}

# Create EC2 Instance
resource "aws_instance" "windows-server" {
  count                       = "${var.instance_count}"
  ami                         = "ami-0067ca69" # Windows 2008 R2 Rightscale w/IIS7
  #ami                         = data.aws_ami.windows-2019.id
  instance_type               = var.windows_instance_type
  subnet_id                   = aws_subnet.public-subnet.id
  vpc_security_group_ids      = [aws_security_group.aws-windows-sg.id]
  associate_public_ip_address = var.windows_associate_public_ip_address
  source_dest_check           = false
  key_name                    = "myKey"
  user_data                   = data.template_file.windows-userdata.rendered
  get_password_data           = true
  
  # root disk
  root_block_device {
    volume_size           = var.windows_root_volume_size
    volume_type           = var.windows_root_volume_type
    delete_on_termination = true
    encrypted             = true
  }

  # extra disk
  ebs_block_device {
    device_name           = "/dev/xvda"
    volume_size           = var.windows_data_volume_size
    volume_type           = var.windows_data_volume_type
    encrypted             = true
    delete_on_termination = true
  }

  tags = {
  Name        = "winsrv-${format("%02d", count.index + 1)}"
  Environment = var.app_environment
  }
}

resource "null_resource" "windows-server" {
  count = 1

  triggers = {
    password = "${rsadecrypt(aws_instance.windows-server.*.password_data[count.index], file("./myKey.pem"))}"
  }
}





# Define the security group for the Windows server
resource "aws_security_group" "aws-windows-sg" {
  name        = "windows-sg"
  description = "Allow incoming connections"
  vpc_id      = aws_vpc.vpc.id
  
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming HTTP connections"
  }

  ingress {
    from_port   = 3389
    to_port     = 3389
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow incoming RDP connections"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name        = "${var.app_environment}-windows-sg"
    Environment = var.app_environment
  }
}
