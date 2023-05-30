
just have terraform installed on your local from here

then clone this repository,

edit your provider and region
then use terraform init
terraform plan
terraform apply --auto-approve 

to start up a jenkins server that you wont need anything in the aws console.
read the code to see the infrastucture you are building
these includes vpc,subnets,instances 
