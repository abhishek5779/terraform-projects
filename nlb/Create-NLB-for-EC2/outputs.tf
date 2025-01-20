output "NLB-DNS-Name" {
    value = aws_lb.NLB.dns_name
    description = "DNS Name of the Network Load Balancer"
}