# Step 1 - Provision the Jenkins server (handout main.tf).
# Changes from the handout: the hardcoded "ami-0abcdef12345" is not a valid AMI ID, so the
# AMI is looked up (latest Ubuntu from Canonical) and can be overridden with -var ami_id=...
provider "aws" {
  region = "ap-south-1"
}

variable "ami_id" {
  description = "AMI for the Jenkins server (empty = latest Canonical Ubuntu)"
  type        = string
  default     = ""
}

data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd*/ubuntu-*-amd64-server-*"]
  }
}

resource "aws_instance" "jenkins" {
  ami           = var.ami_id != "" ? var.ami_id : data.aws_ami.ubuntu.id
  instance_type = "t2.medium"

  tags = {
    Name = "jenkins-bluegreen"
  }
}

output "jenkins_instance_id" {
  value = aws_instance.jenkins.id
}

output "jenkins_ami" {
  value = aws_instance.jenkins.ami
}
