# Create private route table
resource "aws_route_table" "private_rtb" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-private-rtb", var.name)
    }
  )
}

# Associate private subnets to private route table
resource "aws_route_table_association" "private_subnet_association" {
  count          = length(aws_subnet.private_subnet[*].id)
  subnet_id      = element(aws_subnet.private_subnet[*].id, count.index)
  route_table_id = aws_route_table.private_rtb.id
}

