# Amazon Cognito identity platform Deployment

This repository contains the Terraform code and AWS infrastructure setup for deploying a Amazon Cognito identity platform. The Amazon Cognito identity platform includes an API Gateway endpoint, Lambda function, and Cognito user pool for authentication.

## Prerequisites

Before deploying the Amazon Cognito identity platform, make sure you have the following prerequisites:

- AWS account credentials with appropriate permissions
- Terraform installed on your local machine

## Getting Started

Follow the steps below to deploy the Amazon Cognito identity platform:

1. Clone this repository to your local machine.

2. Navigate to the repository directory.

3. Update the `variables.tf` file with your desired configuration, such as the API name, region, and stage name.

4. Initialize Terraform by running the following command:
terraform init

5. Preview the resources that will be created by running the following command:
terraform plan


6. Deploy the infrastructure by running the following command:
terraform apply -auto-approve


7. After the deployment is complete, you will see the API Gateway URL and other relevant outputs. You will need to add user to the pool, run the following bash:
#!/bin/bash

user_pool_id=$(terraform output -raw user_pool_id)
#api_gateway_arn=$(terraform output -raw  api_gateway_arn | cut -d ":" -f 6)
client_id=$(terraform output -raw client_id)

#echo "api_gateway_arn: $api_gateway_arn"
echo "User pool id: $user_pool_id"
echo "Client id of the cognito user pool client: $client_id"

aws cognito-idp sign-up \
    --client-id $client_id \
    --username abylch@hotmail.com \
    --password Pass@1234 \
    --user-attributes Name="email",Value="abylch@hotmail.com" Name="name",Value="Jabylch" \
    --region us-west-1 \
    --profile default

aws cognito-idp admin-confirm-sign-up \
    --user-pool-id $user_pool_id \
    --username abylch@hotmail.com \
    --region  us-west-1 \
    --profile default 

aws cognito-idp admin-update-user-attributes \
    --user-pool-id $user_pool_id \
    --username abylch@hotmail.com \
    --user-attributes Name=email_verified,Value=true \
    --region us-west-1 \
    --profile default

8. Test the API by sending requests to the API Gateway URL. Make sure to include the necessary authentication headers if required. Try the following command example:
TOKEN=$(aws cognito-idp initiate-auth \
    --auth-flow USER_PASSWORD_AUTH \
    --client-id 6ee837kngj5d74n1f4ga59cddr \
    --auth-parameters USERNAME=abylch@hotmail.com,PASSWORD=Pass@1234 \
    --query 'AuthenticationResult.IdToken' \
    --output text)
curl -X GET https://2hmnj999ic.execute-api.us-west-1.amazonaws.com/stage-01/users \
    -H "Authorization: Bearer $TOKEN"

!@##$ response: "Hello from the backend API!"

## Folder Structure

- `main.tf`: Defines the main Terraform configuration, including the resources for API Gateway, Lambda function, Cognito user pool, and other dependencies.

- `variables.tf`: Contains the variable definitions used in the Terraform configuration.

- `outputs.tf`: Defines the outputs that are displayed after the deployment.

- `cognito.tf`: Sets up the Cognito user pool and app client for user authentication.

- `lambda_function.zip`: Contains the Lambda function code in a ZIP file.

- `README.md`: Provides instructions and information about the deployment.

## Cleanup

To clean up and delete the resources created by Terraform, run the following command:


## Conclusion

With this Terraform code, you have successfully deployed the Amazon Cognito identity platform infrastructure, including API Gateway, Lambda function, and Cognito user pool. Feel free to customize and extend the code to meet your specific requirements.




