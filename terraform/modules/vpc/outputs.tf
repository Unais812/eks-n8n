output "vpc_id" {
  value = aws_vpc.n8n-vpc.id
}

output "public-subnet-1" {
  value = aws_subnet.public-1.id
}

output "private-subnet-1" {
  value = aws_subnet.private-1.id
}

output "public-subnet-2" {
  value = aws_subnet.public-2.id
}

output "private-subnet-2" {
  value = aws_subnet.private-2.id
}