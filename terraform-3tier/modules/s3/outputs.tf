output "bucket_names" {
  value = {
    for key, bucket in aws_s3_bucket.buckets :
    key => bucket.bucket
  }
}

output "file_names" {
  value = {
    for key, object in aws_s3_object.bucket_file :
    key => object.key
  }
}

output "file_locations" {
  value = {
    for key, object in aws_s3_object.bucket_file :
    key => "s3://${object.bucket}/${object.key}"
  }
}