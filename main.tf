provider "aws" {
  region="us-east-1"
}
resource "aws_vpc" "myvpc" {
  cidr_block= "${var.vpc_cidr}"

  tags = {
    Name = "${var.vpc_name}"
  }
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = "${aws_vpc.myvpc.id}"

  tags = {
    Name = "${var.igw_name}"
  }
}


resource "aws_route_table" "myroute" {
  vpc_id = "${aws_vpc.myvpc.id}"

  route {
    cidr_block = "${var.route_cidr}"
    gateway_id = "${aws_internet_gateway.my_igw.id}"
  }

  tags = {
    Name = "${var.route_name}"
  }
}

resource "aws_subnet" "mysub" {
  vpc_id     = "${aws_vpc.myvpc.id}"
  cidr_block = "${var.sub_cidr}"

  tags = {
    Name = "${var.sub_name}"
  }
}

resource "aws_route_table_association" "route_association" {
  subnet_id      = "${aws_subnet.mysub.id}"
  route_table_id = "${aws_route_table.myroute.id}"
}

resource "aws_security_group" "mysg" {
  name        = "${var.sg_name}"
  description = "Allow all inbound traffic"
  vpc_id      = "${aws_vpc.myvpc.id}"

  ingress {
    description = "SSH from VPC"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.sg_name}"
  }
}


resource "aws_instance" "ec2" {
  count = "${var.instance_count}"
  ami = "${var.ami_id}"
  instance_type = "${var.instance_type}"
  key_name = "${var.key_pair_name}"
  subnet_id = "${aws_subnet.mysub.id}"
  security_groups = ["${aws_security_group.mysg.id}"]
  associate_public_ip_address = true

  tags = {
    Environment = "${var.env}"
    Name  = "K8S-${count.index + 1}"

}
}
