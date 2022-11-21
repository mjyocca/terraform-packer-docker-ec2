# Terraform Packer Docker EC2

## About

Learning experiment leveraging Terraform to automate the infrastructure deployments & Packer to automate baking both the EC2 AMI image and Docker images. In additon pushing the docker image to ECR (AWS Elastic Container Registry) via Packer post-processor.

## Setup

**Prerequisites*: 
  - Have Terraform, Packer, & Docker installed on your machine.*
  - Have an AWS account.

### 1. Initial Provisioning
#### Deploy Shared Terraform Config (*./infrastructure/terraform/shared*)

Directory: *./infrastructure/terraform/shared*
```bash
cd ./infrastructure/terraform/shared && \
terraform init && \
terraform apply --auto-approve
```


#### 2. Build AWS EC2 Machine Image with Packer (*./infrastructure/packer/images/*)

Create an **./infrastructure/packer/images/variables.auto.pkrvars.hcl** file

```hcl
aws_account_id = "<YOUR AWS ACCOUNT ID>"
ecr_repository = "terraform-packer-docker-project"
region = "us-east-1"
```

Directory: *./infrastructure/packer/images*
```bash
packer build -var-file="./variables.auto.pkrvars.hcl" ec2.pkr.hcl
```


#### 3. Build Docker Image with packer

*You can alternatively build with regular Dockerfile(s) and script to tag and push to ECR. This is automated with Packer post-processors*

Directory: *./infrastructure/packer/images*
```bash
packer build -var-file="./variables.auto.pkrvars.hcl" docker.pkr.hcl
```

#### 4. Deploy Application Infrastructure

*Since the AWS AMI is built and the Docker image has been pushed to ECR, can deploy EC2 application servers*

This terraform configuration is setup for blue/green deployments. To start out only need one of the blue/green servers.

*./infrastructure/terraform/application*
```bash
terraform init && \
terraform apply \
-var "traffic_distribution=blue" \
-var "enable_green_env=false" \
--auto-approve
```

The blue-green-deployment.sh file is setup to script toggling between blue and green deployments, can reference the `traffic_distribution` output value and determine which was previously promoted as production servers.