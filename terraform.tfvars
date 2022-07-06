# Application Definition 
app_name        = "wapp" # Do NOT enter any spaces
app_environment = "dev"       # Dev, Test, Staging, Prod, etc

# Network
vpc_cidr           = "10.11.0.0/16"
public_subnet_cidr = "10.11.1.0/24"
app_customer = "nice"


# AWS Settings
aws_access_key = "your access key here"
aws_secret_key = "your secret key here"
aws_region     = "us-east-1"

# Windows Virtual Machine
windows_instance_name               = "winsrv01"
windows_instance_type               = "t2.micro"
windows_associate_public_ip_address = true
windows_root_volume_size            = 80
windows_root_volume_type            = "gp2"
windows_data_volume_size            = 10
windows_data_volume_type            = "gp2"
instance_count                      = 6
