output "s3_bucket_name" {
  value       = aws_s3_bucket.terraform_state.bucket
}

output "s3_bucket_region" {
  value       = var.aws_region
}

output "dynamodb_table_name" {
  value       = aws_dynamodb_table.terraform_locks.name
}

output "kms_key_id" {
  value       = aws_kms_key.terraform_state.key_id
}

output "kms_key_arn" {
  value       = aws_kms_key.terraform_state.arn
}