# Create an S3 bucket
resource "aws_s3_bucket" "bucket_01" {
    bucket = "${var.bucket_name}" 
    tags = {
    Name        = "bucket-01"
    Environment = "Dev"
  }   
}
