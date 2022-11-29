output "vpc_id" {
  value       = aws_vpc.main.id
  description = "The VPC id"
}

output "vpc_arn" {
  value       = aws_vpc.main.arn
  description = "the vpc arn"
}


output "gateway_id" {
  value       = aws_internet_gateway.gw.id
  description = "The internet gateway ID"
}

output "gateway_arn" {
  value       = aws_internet_gateway.gw.arn
  description = "The internet gateway ARN"
}
