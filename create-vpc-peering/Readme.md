# Terraform AWS VPC Peering Configuration

This Terraform configuration file sets up a network infrastructure across two AWS regions (`us-east-1` and `us-west-2`). It creates VPCs, subnets, internet gateways, route tables, and security groups, and establishes a VPC peering connection between the two regions.

## Overview

The configuration performs the following actions:

1. **VPC Creation**:
   - Creates a VPC in `us-east-1` (master region) with the specified CIDR block.
   - Creates a VPC in `us-west-2` (worker region) with the specified CIDR block.

2. **Internet Gateways**:
   - Creates an Internet Gateway in both the master and worker VPCs.

3. **Subnets**:
   - Creates subnets in both the master and worker VPCs.

4. **VPC Peering**:
   - Initiates a VPC peering connection from the master VPC to the worker VPC.
   - Accepts the VPC peering connection in the worker VPC.

5. **Route Tables**:
   - Creates route tables in both the master and worker VPCs.
   - Adds routes for internet access and VPC peering.
   - Associates the route tables with the respective VPCs.

6. **Security Groups**:
   - Creates security groups in both the master and worker VPCs to allow specific traffic (e.g., SSH, HTTP, HTTPS).

## Real-World Example

Imagine you have a Jenkins server running in the `us-east-1` region and a load balancer that needs to manage traffic to this Jenkins server. Additionally, you have another set of resources in the `us-west-2` region that need to communicate with the Jenkins server. Using this terraform configuration, VPC peering is established between the VPCs in `us-east-1` and `us-west-2` to facilitate this communication.

### Security Group Configurations

1. **Security Group for Jenkins Server (`master-sg`)**:
   - Allows SSH traffic (TCP port 22) from any IP address.
   - Allows HTTP traffic (TCP port 8080) from any IP address.
   - Allows all traffic from the worker subnet CIDR block.

2. **Security Group for Load Balancer (`master-sg-lb`)**:
   - Allows HTTPS traffic (TCP port 443) from any IP address.
   - Allows HTTP traffic (TCP port 80) from any IP address.
   - Allows traffic to the Jenkins security group.

3. **Security Group for Worker VPC (`worker-sg`)**:
   - Allows SSH traffic (TCP port 22) from any IP address.
   - Allows all traffic from the master subnet CIDR block.

### Usage

1. Initialize the Terraform configuration:
   ```sh
   terraform init

2. Dry run the Terraform configuration:
   ```sh
   terraform plan

3. Apply the Terraform configuration:
   ```sh
   terraform apply

4. Review the outputs to get the IDs of the created resources.

## Notes

- Ensure that your AWS credentials are configured properly.
- Modify the default values of the variables as needed.