# Terraform Configuration for AWS EC2 Auto Scaling and Load Balancing

This Terraform configuration sets up an AWS infrastructure that includes EC2 instances, an Auto Scaling Group (ASG), and an Application Load Balancer (ALB) to ensure high availability and efficient traffic distribution.

## Features

- Fetch details of existing EC2 instances
- Create a Launch Template based on the fetched EC2 instance details
- Create an Auto Scaling Group (ASG)
- Define an Auto Scaling Policy for target tracking
- Create an internet-facing Application Load Balancer (ALB)
- Create a Target Group for the ALB
- Create a Listener for the ALB
- Attach the ASG to the Target Group

## Configuration Details

### Fetch EC2 Instance Details

- Fetch details of running EC2 instances with specific tags (`Web1` and `Web3`).

### Create a Launch Template

- Create a Launch Template using the details of the fetched EC2 instance (`Web1`).

### Create an Auto Scaling Group (ASG)

- Define an ASG with a minimum size of 1, maximum size of 3, and desired capacity of 1.
- Use the created Launch Template for the ASG.
- Specify the subnets for the ASG.

### Define an Auto Scaling Policy

- Create a Target Tracking Scaling policy for the ASG.
- Set the target value for ASGAverageCPUUtilization to 80%.

### Create an Application Load Balancer (ALB)

- Create an internet-facing ALB.
- Use the security groups and subnets of the fetched EC2 instances.

### Create a Target Group for the ALB

- Define a Target Group for the ALB.
- Set the health check configuration.

### Create a Listener for the ALB

- Create a Listener for the ALB on port 80.
- Forward traffic to the defined Target Group.

### Attach ASG to the Target Group

- Attach the ASG to the Target Group to enable load balancing.

## Lab reference-
https://learn.acloud.guru/handson/e2815923-893c-49be-a091-a1f2744dd91e