In this project, we will set up a Network Load Balancer to manage traffic between two EC2 instances located in different subnets and Availability Zones. After creating the NLB, we will conduct a brief test on its DNS to evaluate performance and monitor the results in CloudWatch metrics.

The detailed steps required to complete this project are as follows:

- **Create and Configure a Subnet**
  - Create a public subnet named Public B in the us-east-1b availability zone with a CIDR block of 10.0.2.0/24.
  - Add a route to the existing Internet Gateway.
  - Configure explicit subnet association for Public B.

- **Edit the Network ACL**
  - Modify the Network ACL for Public B to allow traffic on:
    - HTTP (80)
    - HTTPS (443)
    - SSH (22)
    - Ephemeral Ports (1024 - 65535)
    - Create an Egress rule as well for all ports and all protocal. (via AWS console it gets created by default) 

- **Create EC2 Instances**
  - Launch an EC2 instance named WebA using the latest Amazon Linux AMI, type t3.micro, in PublicA subnet with a public IP and the preconfigured EC2 Security group, including WebA user data script.
  - Launch a second EC2 instance in PublicB with the same settings and WebB user data script.

- **Create and Configure a Network Load Balancer**
  - Deploy an Internet-facing Network Load Balancer over IPv4, covering us-east-1a and us-east-1b.
  - Use the default Security Group; create a Target Group with TCP protocol on port 80 and configure Health Check for TCP.
  - Include WebA and WebB as targets and apply the new Target Group.

- **Test and Monitor the Network Load Balancer**
  - Access the Load Balancer DNS name in a browser to confirm page serving from WebA or WebB.
  - Generate traffic to the instances using a command in AdminInstance: `while true; do curl <LOAD BALANCE DNS NAME>; done`.
  - Monitor the Load Balancer's performance under simulated traffic conditions. 


## Lab Reference - 
https://learn.acloud.guru/handson/a0c93cdb-127d-43e5-9026-aea0a8dc5c5d