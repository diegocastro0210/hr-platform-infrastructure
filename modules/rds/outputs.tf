output "endpoint" {
  value = aws_db_instance.main.endpoint
}

output "address" {
  value = aws_db_instance.main.address
}

output "port" {
  value = aws_db_instance.main.port
}

output "database_url" {
  value     = "postgresql://${var.database_username}:${var.database_password}@${aws_db_instance.main.endpoint}/${var.database_name}?schema=public"
  sensitive = true
}
