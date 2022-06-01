# Create Elastic IP
resource "aws_eip" "nat_eip" {
  vpc = true
  #   Depends on Internet gateway
  depends_on = [aws_internet_gateway.igw]

  tags = merge(
    var.tags,
    {
      Name = format("%s-EIP-%s", var.name, aws_vpc.main.id)
    }
  )
}



# Create NAT gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  #   Depends on Internet gateway
  depends_on = [aws_internet_gateway.igw]

  tags = merge(
    var.tags,
    {
      Name = format("%s-NAT-%s", var.name, aws_vpc.main.id)
    }
  )
}
