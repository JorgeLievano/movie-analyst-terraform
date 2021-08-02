variable "ami_ubuntu" {
  description = "Ubuntu 20 AMI id"
  type        = string
  default     = "ami-0d382e80be7ffdae5"
}

variable "api_blue_enable" {
  description = "Value for enable blue api environment"
  type        = bool
  default     = false
}

variable "api_blue_running" {
  description = "Value for start blue env api running"
  type        = bool
  default     = false
}

variable "api_green_enable" {
  description = "Value for enable green api environment"
  type        = bool
  default     = false
}

variable "api_green_running" {
  description = "Value for start green env api running"
  type        = bool
  default     = false
}

variable "availability_zones" {
  description = "Availability zones used set"
  type        = list(string)
  default     = ["us-west-1a", "us-west-1c"]

}

variable "aws_default_tags" {
  description = "Default tags for rampup resources"
  type        = map(string)
  default = {
    application = "movie-analyst"
    project     = "rampup"
  }
}

variable "key_pair_name" {
  description = "Key pair for SSH instances connection"
  type        = string
}

variable "subnet_az_cidr" {
  description = "az and cidr blocks for public and private subnets"
  type        = map(map(string))
  default = {
    private = {
      us-west-1a = "10.1.80.0/21"
      us-west-1c = "10.1.88.0/21"
    }
    public = {
      us-west-1a = "10.1.0.0/21"
      us-west-1c = "10.1.8.0/21"
    }
  }

}

variable "ui_blue_enable" {
  description = "Value for enable blue ui environment"
  type        = bool
  default     = false
}

variable "ui_blue_running" {
  description = "Value for start blue env ui running"
  type        = bool
  default     = false
}

variable "ui_green_enable" {
  description = "Value for enable green ui environment"
  type        = bool
  default     = false
}

variable "ui_green_running" {
  description = "Value for start green env ui running"
  type        = bool
  default     = false
}
