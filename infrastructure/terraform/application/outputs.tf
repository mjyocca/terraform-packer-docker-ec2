output "lb_dns_name" {
  value = aws_lb.app.dns_name
}

output "traffic_distribution" {
  value = var.traffic_distribution
}