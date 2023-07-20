resource "aws_dynamodb_table" "user_table" {
  name           = var.aws_dynamodb_table_name
  hash_key       = "username"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  range_key      = "timestamp"
  attribute {
    name = "username"
    type = "S"
  }
  attribute {
    name = "timestamp"
    type = "S"
  }
}
