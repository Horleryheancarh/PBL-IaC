resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    {
      Name = format("%s-IG-%s", var.name, aws_vpc.main.id)
    }
  )
}
