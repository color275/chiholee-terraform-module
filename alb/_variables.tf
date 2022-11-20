variable "vpc_id" {
    type = string
}

variable "project_name" {
    type = string
}

variable "ec2_name" {
    type = string
}


variable "subnet_ids" {
    type = list
}

variable "listener_port" {
    type = number
}

variable "target_group_port" {
    type = number
}

variable "internal" {
  type = bool  
  default = false
}


variable "ingress_rules" {
  type = list(tuple([string, string, string, list(string), string, string]))
  default = []
}

variable "https_yn" {
  type = bool  
  default = false
}

variable certificate_arn {
  type = string  
  default = null
}