# NiceExam

Deployment Instructions:
Clone the Repository:

git clone git@github.com:eldarsh1/NiceExam.git

cd <repository_directory>

Modify Variables:
Edit the main.tf file to update the following variables:

Replace "ami-xxxxxxxxxxxxxxxx" with the actual AMI ID for your desired instance type and region.
Change "your-key-pair" to your EC2 key pair name.
Ensure the source path in the provisioner block points to the correct location of your "hello_world.html" file.
Initialize Terraform:

terraform init
#######################Deployment#######################
Deploy Infrastructure:

terraform apply
Terraform will prompt you to confirm the changes. Type yes and press Enter.

Access the Deployed Website:
Once the deployment is complete, note the public IP address from the Terraform output. Open a web browser and visit http://<public_ip> to see the "Hello, World!" webpage.

#####################Teardown Instructions:###########################
Destroy Infrastructure:


terraform destroy
Terraform will prompt you to confirm the destruction of resources. Type yes and press Enter.

Confirm Deletion:
Terraform will show a summary of resources to be destroyed. Type yes and press Enter to proceed with the teardown.

Cleanup Local Files:


rm -rf .terraform
rm -f terraform.tfstate*
This step removes Terraform state files and configuration files from your local directory.

