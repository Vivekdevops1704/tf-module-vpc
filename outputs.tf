output "subnets" {
  value = module.subnets
}

output "vpc_id" {
  value = aws_vpc.main.id
}
 output "public_subnet_id" {
  value = local.app_subnet_ids
 }
 output "default_vpc_id" {
  value = aws_vpc.main.id
 }