output "api_gateway_arn" {
  value = aws_api_gateway_rest_api.api.execution_arn
  description = "api_gateway_arn"
}

output "user_pool_id" {
  value = aws_cognito_user_pool.user_pool.id
  description = "user pool id"
}

# run to print --> terraform output api_gateway_url
output "api_gateway_url" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
  description = "API Gateway url"
}

output "client_id" {
  value = aws_cognito_user_pool_client.user_pool_client.id
  description = "Client id of the cognito user pool client"
}