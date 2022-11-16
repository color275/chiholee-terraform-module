output write_endpoint {
  value = aws_rds_cluster.main.endpoint
}

output read_endpoint {
  value = aws_rds_cluster.main.reader_endpoint
}