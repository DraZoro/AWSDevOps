output "vpc_id" {
    value = aws_vpc.main.id
    description = "The VPC id"
}

output "vpc_arn" {
    value = aws_vpc.main.arn
    description = "The VPC ARN"
}