#!/bin/bash

user_pool_id=$(terraform output -raw user_pool_id)
api_gateway_arn=$(terraform output -raw  api_gateway_arn | cut -d ":" -f 6)
client_id=$(terraform output -raw client_id)

echo "api_gateway_arn: $api_gateway_arn"
echo "User pool id: $user_pool_id"
echo "Client id of the cognito user pool client: $client_id"

TOKEN=$(aws cognito-idp initiate-auth \
    --auth-flow USER_PASSWORD_AUTH \
    --client-id $client_id \
    --auth-parameters USERNAME=abylch@hotmail.com,PASSWORD=Pass@1234 \
    --query 'AuthenticationResult.IdToken' \
    --output text)
curl -X GET https://$api_gateway_arn.execute-api.us-west-1.amazonaws.com/stage-01/users \
    -H "Authorization: Bearer $TOKEN"
