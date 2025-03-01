output "Peering-Connection-ID" {
  value = aws_vpc_peering_connection.master-to-worker.id
}

output "Master-VPC-ID" {
    value = aws_vpc.master-vpc.id
}

output "Worker-VPC-ID" {
    value = aws_vpc.worker-vpc.id
}