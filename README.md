this is a straightforward project to deploy an AWS ec2 instance with a Jenkins server setup all in a single terraform code and have our Jenkin's server IP and Jenkin's initial password output for us in the terminal.

Purpose: we can deploy any server using the terraform “null_resource” and have it up and ready in a few seconds. Also, we don’t have to manually create an instance or configure Jenkins from the ec2 terminal.

Tools needed: GitHub, terraform, Jenkins shell script.

Workflow:

    have two files in your workspace(main.tf and jenkins_script.sh)

    the first file, main.tf will contain the terraform code.

    The other will contain the shell script to install Jenkins on any Ubuntu server(uses apt)

The main.tf file:
create the provider block

create a default vpc

    the region we are deploying the ec2 server

    the was authentication profile we are using

    the name we are giving our vpc

create an availability zone using data

    using a default availability zone

    using the default availability zone for our subnet

create security group for the instance

    allowing port 22 in the ec2 so Terrafrom can connect to the ec2 instance with it's key using ssh.

    allowing port 8080 so we can access Jenkins server in the browser(jenkin's port)

    the name we are giving the security group

create the aws instance for the jenkins server

    the ami for the instance(be sure it's the one that's from the same region in the Provider block, and the type of the instance also. in our case t2.micro)

    used the created subnet and vpc which is in a list

    this is the name of the ssh-keypair used for AWS resorces

    the name of the instance

create a null_resource block for the server

    the first block establishes a ssh connection between terraform and the ec2instance using the the downloaded aws key-pair file's path and the name of the instance.

    the provisioned block copies the install_jenkins file from our workspace to the instance

    the second provisioner block makes the file executable then run the file.

    the last block says the whole null_source block depends on if the server is up.

create output block to output the link(IP and port) to use Jenkins

this block output the link to access the jenkins server in our browser.

the jenkins_script.sh file: This has all the commands needed to get jenkins up and running. And also give us the initial password to start using Jenkins in ubuntu(this is because our script uses apt). You can use the script for other Linux distros just by editing the commands to use on your preferred linux .

Running the deployment:

terraform init

terraform plan

terraform apply --auto-approve

    the initial password to access jenkins

    confirmation of the deployment

    the link to jenkins server

good luck!!
