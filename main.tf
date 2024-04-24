provider "aws" {
   region = "us-east-1"
   access_key                   = "REPLACE WITH ACCESS-KEY"
   secret_key                   = "REPLACE WITH SECRET-KEY"
}

resource "aws_instance" "secsummit" {
   ami                          = "ami-049489b50a99d699e"
   instance_type                = "t3.medium"
   availability_zone            = "us-east-1a"
   subnet_id                    = "subnet-0d5c186030bace6ac"
   vpc_security_group_ids       = ["sg-0c876601fb0458327","sg-0515941d9ff896138"]
   key_name                     = "SecuritySummit"
   associate_public_ip_address  = true 

   user_data = <<-EOF
       Section: IOS configuration
       hostname secsummit
       ip domain name cisco.local
       aaa new-model
       aaa authentication login default local
       crypto key generate rsa general-keys modulus 4096
       ip ssh version 2
       username cisco123 privilege 15 secret cisco123
       enable secret cisco123
       interface GigabitEthernet1
       no ipv6 address dhcp
   EOF
   
   #provisioner "local-exec" {
   #   command = "ansible-playbook vpn.yaml --extra-vars 'router_public=${aws_instance.secsummit.public_ip}'"
   #}
}

output "instance_public_ip" {
   value                        = aws_instance.secsummit.public_ip
}

output "instance_private_ip" {
   value                        = aws_instance.secsummit.private_ip
}
