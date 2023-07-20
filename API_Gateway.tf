# Create the API Gateway REST API
resource "aws_api_gateway_rest_api" "api" {
  name        = var.api_name
  description = var.api_name
  endpoint_configuration {
    types = ["REGIONAL"]
  }
}

# API url path
resource "aws_api_gateway_resource" "api_resource" {
  rest_api_id = aws_api_gateway_rest_api.api.id
  parent_id   = aws_api_gateway_rest_api.api.root_resource_id
  path_part   = "users"  # Replace with the desired resource path: https://2hmnj999ic.execute-api.us-west-1.amazonaws.com/stage-01/users
}

# Define at least one method in the API Gateway REST API before creating the deployment
resource "aws_api_gateway_method" "api_method" {
  rest_api_id   = aws_api_gateway_rest_api.api.id
  resource_id   = aws_api_gateway_resource.api_resource.id
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS" // "COGNITO_USER_POOLS" in authorizer
  authorizer_id = aws_api_gateway_authorizer.authorizer.id
}

# Integration for the method in the API Gateway resource
resource "aws_api_gateway_integration" "api_integration" {
  rest_api_id             = aws_api_gateway_rest_api.api.id
  resource_id             = aws_api_gateway_resource.api_resource.id
  http_method             = aws_api_gateway_method.api_method.http_method
  integration_http_method = "GET"
  type                    = "AWS_PROXY"
  uri                     = aws_lambda_function.lambda_function.invoke_arn

}

# Create an API Gateway deploymen
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/api_gateway_deployment
resource "aws_api_gateway_deployment" "api_deployment" {
  depends_on    = [aws_api_gateway_integration.api_integration]
  rest_api_id = aws_api_gateway_rest_api.api.id
  stage_name  = var.stage_name //  (Optional) Name of the stage to create with this deployment.
}

resource "aws_api_gateway_authorizer" "authorizer" {
  name               = "authorizer-01-lambda"
  rest_api_id        = aws_api_gateway_rest_api.api.id
  #authorizer_uri         = aws_lambda_function.lambda_function.invoke_arn
  #authorizer_credentials = aws_iam_role.lambda_function_role.arn
  identity_source    = "method.request.header.Authorization"
  type               = "COGNITO_USER_POOLS"
  provider_arns      = [aws_cognito_user_pool.user_pool.arn]
}

