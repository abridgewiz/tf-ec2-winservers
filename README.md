# Deploy AWS Windows Server EC2 Instances Using Terraform

Deploying a Windows Server EC2 Instance in AWS using Terraform

To update the version of Windows Server, just update the ami line in the **windows-vm-main.tf** file, with a variable from the **windows-versions.tf** file.

In this file, we support latest versions of:

- Windows Server 2022
- Windows Server 2019
- Windows Server 2016
- Windows Server 2012 R2 

For deploying only Windows 2008 R2 add the **ami = "ami-0067ca69"** This AMI is one of a few 2008 R2 images avaible in the markplace

Create an SSH key named "myKey" in AWS and copy "myKey.pem" to the root folder of the terraform scripts
