output "ALB_DNS" {
    value = aws_lb.myalb.dns_name
    description = "DNS value of the ALB"
}