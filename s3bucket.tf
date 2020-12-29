provider "aws" {

		region="${var.aws_region}"
		
	}

#create random id for S3 bucket name

resource "random_id" "myrandomid" {

  byte_length = 2
}


# creating S3 bucket

resource "aws_s3_bucket" "mys3bucket" {
  bucket = "${var.bucket_name}-${random_id.myrandomid.dec}"
  force_destroy = "true"

  tags = {
    Name        = "${var.bucket_name}"
  }
}
