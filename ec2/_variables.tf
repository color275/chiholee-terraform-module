variable "env" {
  type = string
}

variable "project_name" {
  type = string
}

variable "vpc_id" {
  type = string
}


variable "subnet_ids" {
  type = list
}

variable "security_groups" {
  type = string
  default = null
}


variable "ami_name" {
  type = string
}

variable "ami_owners" {
  type = list
  default = ["self"]
}



variable "cnt" {
  type = number
}
variable "ec2_name" {
  type = string
}
variable "instance_type" {
  type = string
}
variable "volume_size" {
  type = string
}
variable "volume_type" {
  type = string
  default = "gp2"
}

variable "volume_iops" {
  type = string
  default = null
}

variable "key_name" {
  type = string
}

variable "ingress_rules" {
  type = list(tuple([string, string, string, list(string), string, string]))
  default = []
}


variable "managed_policy_arns" {
  type = list
  default = []
}

variable auto_on_off {
  type        = bool
  default = false
}

variable eip_yn {
  type        = bool
  default = true
}