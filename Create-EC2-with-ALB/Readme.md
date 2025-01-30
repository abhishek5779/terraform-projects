# AWS Infrastructure Configuration with Terraform

This Terraform configuration project sets up an AWS EC2 infrastructure across multiple Availability Zones to ensure high availability. It includes an Application Load Balancer (ALB) to distribute traffic evenly across the EC2 instances. This design enhances fault tolerance and reliability by balancing the load and providing redundancy.

## Resources Created

1. **VPC**
   - Creates a VPC with a CIDR block of `10.0.0.0/16`.

2. **Subnets**
   - Creates two subnets within the VPC:
     - `subnet1` with CIDR block `10.0.2.0/24` in `us-east-1a`.
     - `subnet2` with CIDR block `10.0.3.0/24` in `us-east-1b`.

3. **Internet Gateway**
   - Creates an internet gateway and attaches it to the VPC.

4. **Route Table**
   - Creates a route table with a route to the internet gateway and associates it with both subnets.

5. **Security Group**
   - Creates a security group allowing HTTP (port 80) and SSH (port 22) traffic.

6. **Key Pair**
   - Creates an AWS key pair using a public key from the local machine.

7. **EC2 Instances**
   - Launches two EC2 instances (`server1` and `server2`) in the respective subnets with the specified AMI and instance type.

8. **Application Load Balancer (ALB)**
   - Creates an ALB and configures it to use the security group and subnets.

9. **Target Group**
   - Creates a target group for the ALB and attaches the EC2 instances to it.

10. **ALB Listener**
    - Configures an ALB listener to forward traffic to the target group.

## Lab reference-
https://learn.acloud.guru/handson/d901786a-b8a6-404c-9fc2-d55cf103f5ff