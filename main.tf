resource "aws_vpc" "main" {
  cidr_block       =   var.cidr
}
module "subnets" {
 source = "./subnets"
 for_each = var.subnets
 subnets = each.value
 vpc_id = aws_vpc.main.id
}
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "main"
  }
}
resource "aws_route" "igw" {
  //for_each =  lookup(lookup(module.subnets,"public",null),"route_table_id",null)
  count  = local.private_route_table_ids
  route_table_id            = element(local.private_route_table_ids, count.index)
  destination_cidr_block    = "0.0.0.0/0"
  nat_gateway_id = element(aws_nat_gateway.ngw.*.id, count.index)
}
resource "aws_nat_gateway" "ngw" {
  //for_each =  lookup(lookup(module.subnets,"public",null),"subnet_ids",null)
  count = local.public_subnet_ids
  //allocation_id = lookup(lookup(aws_eip.ngw,each.key,null),"id",null)
  allocation_id = element(aws_eip.ngw.*.id, count.index)
  subnet_id =   element(local.public_subnet_ids, count.index)
}
resource "aws_eip" "ngw" {
  for_each =  lookup(lookup(module.subnets,"public",null),"route_table_id",null)
  domain   = "vpc"
}