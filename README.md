# terraform_jenkins_serverup
this is a straightforward project to deploy an AWS ec2 instance with a Jenkins server setup all in a single terraform code and have our Jenkin's server IP and Jenkin's initial password output for us in the terminal.

Purpose: we can deploy any server using the terraform “null_resource” and have it up and ready in a few seconds. Also, we don’t have to manually create an instance or configure Jenkins from the ec2 terminal.

Tools needed:GitHub,terraformJenkins shell script.



Workflow:

have two files in your workspace(main.tf and jenkins_script.sh)

the first file, main.tf will contain the terraform code.

The other will contain the shell script to install jenkins on any ubuntu server(uses apt)


the main.tf file:

create the provider block

create a default vpc

create an availability zone using data

create security group for the instance

create the aws instance for the jenkins server

create null_resource block for the server

create output block to output the link(IP and port) to use Jenkins

the jenkins_script.sh file: This has all the commands needed to get jenkins up and running. And also give us the initial password to start using Jenkins in ubuntu(this is because our script uses apt). You can use the script for other Linux distros just by editing the commands to use on your preferred linux .

Running the deployment:

terraform init

terraform plan

terraform apply --auto-approve

