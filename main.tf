provider "aws" {
  region = "us-east-1"
  profile = "myaws"
}

resource "aws_default_vpc" "default" { //(1) default resource with tag name
  tags = {
    Name = "Default VPC"
  }
}

# Declare the data source
data "aws_availability_zones" "available" {}     //(2) default resource


resource "aws_default_subnet" "default_az1" {
  availability_zone = data.aws_availability_zones.available.names[0]  //we integrate the avail-zone from data to use the first avz in the list
  tags = {
    Name = "Default subnet for us-east-1a"
  }
}


resource "aws_security_group" "allow_tls" {          // we are creating sg for 2 ports we will be allowing 
  name        = "allow_tls"
  description = "Allow 8080 and 22  inbound traffic"
  vpc_id      = aws_default_vpc.default.id            // integrate the vpc from the default above.

  ingress {
    description      = "ssh access"
    from_port        = 22
    to_port          = 22                         // dublicate the ingress to have both ports, make it dynamic.
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  ingress {
    description      = "http access"
    from_port        = 8080
    to_port          = 8080
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow_tls"
  }
}

resource "aws_instance" "jenkins_server" {                    //edit the instance name
  ami           = "ami-007855ac798b5175e"               # change the ami to use the one from the same region.(us-east-1 in this case)
  instance_type = "t2.micro"
  subnet_id = aws_default_subnet.default_az1.id         # addition of the subnet from above
  vpc_security_group_ids = [aws_security_group.allow_tls.id]
  key_name = "checkup" #this should be the key already in the aws account

  tags = {
    "Name" = "terraform_Jenkins_server"                             # make variables out of all and modulize everyting 
  }
}

resource "null_resource" "name" {
  

  #SSH into ec2 instance

  connection {
    type = "ssh"
    user = "ubuntu"
    private_key = file("~/Documents/checkup.pem")          //use the pem key path here
    host = aws_instance.jenkins_server.public_ip
  }

  #copy the install_jenkins.sh file from local to ec2 instance.

  provisioner "file"{
    source = "install_jenkins.sh"                       // the shell file we are transfering
    destination = "/tmp/install_jenkins.sh"
  }

  # set permission and execute the install_jenkins.sh file

  provisioner "remote-exec"{
    inline = [
      "sudo chmod +x /tmp/install_jenkins.sh",
      "sudo sh /tmp/install_jenkins.sh"

    ]
  }
   depends_on = [                           // this must start and be ready before the null resource starts.
    aws_instance.jenkins_server
  ]
}

output "jenkins_url" {
  value = join("",["http://",aws_instance.jenkins_server.public_dns,":","8080"])
}


# resource "null_resource" "name" {
  

#   #SSH into ec2 instance

#   connection {
#     type = ""
#     user = ""
#     private_key = ""
#     host = ""
#   }

#   #copy the install_jenkins.sh file from local to ec2 instance.

#   provisioner "file"{
#     source = ""
#     destination = ""
#   }

#   # set permission and execute the install_jenkins.sh file

#   provisioner "remote-exec"{
#     inline = [

#     ]
#   }
#   depends_on = [
#     aws_instance.jenkins_server
#   ]
# }

