resource "aws_route_table_association" "app" {
  count = length(aws_subnet.app)
  route_table_id = aws_route_table.app[count.index].id
  subnet_id = aws_subnet.app[count.index].id
}