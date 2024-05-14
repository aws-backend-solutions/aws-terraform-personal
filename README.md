# Terraform Project

This Terraform project is designed to provision and manage infrastructure resources using Terraform to our AWS environment.


## Getting Started

To get started with this project, follow these steps:

1. **Install Terraform:**
   Ensure that Terraform is installed on your machine. You can download Terraform from the [official website](https://www.terraform.io/downloads.html) or use a package manager.

2. **Initialize Terraform:**
   Run `terraform init` to initialize the working directory containing Terraform configuration files.

3. **Review Variables:**
   Review the variables in `variables.tf` and provide appropriate values either by updating the variables directly or by using input variables.

   <!-- Review the us-dev/../variables.tf to get a grasp of each variables definitions before assigned vlaues to them in Step #5. -->

4. **Plan Infrastructure:**
   Run `terraform plan` to create an execution plan. This step will show you what Terraform will do when you run `terraform apply`.

5. **Apply Infrastructure Changes:**
   Run `terraform apply` to apply the changes required to reach the desired state of the configuration.