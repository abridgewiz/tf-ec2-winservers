#####################################
## Virtual Machine Module - Output ##
#####################################

#output "vm_windows_server_instance_name" {
#  value = var.windows_instance_name
#}

output "tags" {
description = "List of tags of instances"
value       = aws_instance.windows-server.*.tags.Name
}

#output "vm_windows_server_instance_id" {
#  value = "${element(aws_instance.windows-server.*.id, 0)}"
#}


#output "Administrator_Password" {
#    value = "${null_resource.windows-server.*.triggers.password}"
#}

output "private_ips" {
description = "List of private IP addresse all instances"
value       = [aws_instance.windows-server.*.private_ip]
}

output "vm_public_dns" {
  value = [aws_instance.windows-server.*.public_dns]
}

output "Administrator_Password" {
  value = [
    for i in aws_instance.windows-server : rsadecrypt(i.password_data, file("myKey.pem"))
  ]
}