output "vpc_id" {
  value = aws_vpc.n8n-vpc.id
}

output "private_subnet_ids" {
  value = [
    for k, subnet in aws_subnet.subnets :
    subnet.id
    if !local.subnets[k].public
  ]
}

output "public_subnet_ids" {
  value = [
    for k, subnet in aws_subnet.subnets :
    subnet.id
    if local.subnets[k].public
  ]
}
