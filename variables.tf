variable "ami_ubuntu" {
  description = "Ubuntu 20 AMI id"
  type        = string
  default     = "ami-0d382e80be7ffdae5"
}

variable "aws_default_tags" {
  description = "Default tags for rampup resources"
  type        = map(string)
  default = {
    responsible = "jorge.lievanos"
    project     = "jorgelievanos-rampup"
  }
}

variable "key_pair_name" {
  description = "Key pair for SSH instances connection"
  type        = string
  default     = "jlievanos-rampup-devops"
}
