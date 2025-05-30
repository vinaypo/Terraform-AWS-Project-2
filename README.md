
# Terraform Modules Project

In typical infrastructure deployments, environments like dev, QA, and production might have different requirements (e.g., dev doesn’t need a load balancer or Route53). Managing these differences with a single Terraform codebase can lead to manual changes, which is inefficient. By breaking the code into modules, you can dynamically include/exclude components based on environment requirements, making the infrastructure easier to manage.

## Solution

We break the infrastructure into the following modules:

VPC: VPC, subnets, routing, Internet Gateway, NAT Gateway etc..
EC2: EC2 instances (public(bastion host) and private)
Security Groups (SG): For securing VPC resources
ELB: Elastic Load Balancers 
Autoscaling: for Scaling the Instances based on the load

### Folder Structure

```
/modules
  ├── VPC
  ├── SecurityGroup
  ├── Public-Instance
  ├── Private-Instance
  ├── ELB
  ├── AutoScaling
/development
  ├── main.tf
  ├── provider.tf
  ├── variables.tf
  ├── terraform.tfvars
/production
  ├── main.tf
  ├── provider.tf
  ├── variables.tf
  ├── terraform.tfvars
```

## Step-by-Step Setup

### 1. Create VPC Module

1. **Import Network Module in Development:**
   - In `/development/main.tf`, import the network module:
     ```hcl
     module "vpc" {
       source = "../modules/vpc"
       # Specify the necessary variables
       vpc_cidr = var.vpc_cidr
       ...
     }
     ```

3. **Deploy the Network Module:**
   ```bash
   cd development
   terraform init
   terraform fmt
   terraform validate
   terraform apply
   ```

### 2. Configure for Production
  - Ensure variable values are updated (e.g., CIDR blocks should not overlap between environments).

- **Customize Values**: Modify `terraform.tfvars` and `variables.tf` in the `production` folder to match production settings (e.g., CIDR range, env = "production").

```bash
cd production
terraform init
terraform fmt
terraform apply
```

4. **Replicate for Production**: Similarly, copy the security group module to `production`, making necessary adjustments.

### 3. EC2 (Compute) Module

1. **Create `/modules/EC2`:**
   - `main.tf`: For private EC2 instances.
   - `variables.tf`: Define EC2-related variables.
   - `outputs.tf`: Export EC2 instance IDs or other resources.

2. **Deploy in Development**: Add EC2 configuration in `development/main.tf`, referencing the module:
   ```hcl
   module "dev_compute_1" {
     source = "../modules/EC2"
     vpc_id = module.dev_vpc_1.vpc_id
     ...
   }
   ```


### Final Steps

- **Destroy**: To clean up, run the following in both environments:
  ```bash
  cd production
  terraform destroy -auto-approve
  cd development
  terraform destroy -auto-approve
  ```

## Key Terraform Commands

- **Format and Validate**:
  ```bash
  terraform fmt
  terraform validate
  ```
- **Initialize**:
  ```bash
  terraform init
  ```
- **Apply Changes**:
  ```bash
  terraform apply
  ```
- **Check State**:
  ```bash
  terraform state list
  ```

## Notes on Output Values

The `output.tf` files in each module play a crucial role in passing data between modules. For example, the VPC module exports the `vpc_id`, which is consumed by the Security Group module and EC2 module. This modular approach helps ensure that all components are properly linked, and their dependencies are clear.

## Conclusion

This repository demonstrates how to efficiently manage and deploy infrastructure across multiple environments using Terraform modules. By breaking infrastructure code into reusable modules, we reduce complexity, manual work, and potential errors, leading to a more scalable and maintainable solution.
