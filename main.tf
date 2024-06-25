provider "aws" {
  region = "us-west-2"
}

resource "aws_instance" "app_server" {
  count = var.instance_count
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "AppServer"
    Environment = var.environment
  }
}
