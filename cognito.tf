# Create a Cognito User Pool
resource "aws_cognito_user_pool" "user_pool" {
  name = var.user_pool_name

  tags = {
    Name = var.user_pool_name
  }
  
}

# Create a Cognito User Pool Client
resource "aws_cognito_user_pool_client" "user_pool_client" {
  name               = var.user_pool_client_name
  user_pool_id       = aws_cognito_user_pool.user_pool.id
  generate_secret    = false

  # TODO: Additional configuration for the user pool client
  explicit_auth_flows = [
    "ALLOW_USER_PASSWORD_AUTH",
    "ALLOW_USER_SRP_AUTH",
    "ALLOW_REFRESH_TOKEN_AUTH"
  ]
}

resource "aws_cognito_identity_pool" "identity_pool" {
  identity_pool_name             = var.identity_pool_name
  allow_unauthenticated_identities = false

  cognito_identity_providers {
    client_id     = aws_cognito_user_pool_client.user_pool_client.id
    provider_name = aws_cognito_user_pool.user_pool.endpoint
  }
}



