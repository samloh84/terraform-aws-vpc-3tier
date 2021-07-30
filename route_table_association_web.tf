resource "aws_route_table_association" "web" {
  count = length(aws_subnet.web)
  route_table_id = aws_route_table.web.id
  subnet_id = aws_subnet.web[count.index].id
}