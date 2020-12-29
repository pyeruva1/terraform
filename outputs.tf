output "mys3bucket" {
        value = "${aws_s3_bucket.mys3bucket.bucket_domain_name}"
}
