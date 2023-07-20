# resource "aws_route53_record" "api_record" {
#   zone_id = var.route53_zone_id
#   name    = "api.qamonkeys.com"
#   type    = "CNAME"
#   ttl     = 300
#   records = [aws_api_gateway_deployment.api_deployment.invoke_url]
# }
