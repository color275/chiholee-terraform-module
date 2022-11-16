variable "natgateway_yn" {
  type    = bool
  default = false
}

variable "bastion_instance_yn" {
  type    = bool
  default = false
}

variable "bastion_ami_name" {
  type = string
}

variable "bastion_ami_owners" {
  type    = list(any)
  default = ["self"]
}

variable "bastion_instance_type" {
  type = string
}

variable "key_name" {
  type = string
  default = null
}

variable "ssm_endpoint_yn" {
  type    = bool
  default = false
}

variable "cicd_endpoint_yn" {
  type    = bool
  default = false
}

variable "codeseries_endpoint_yn" {
  type    = bool
  default = false
}

variable "vpc_cidr" {
  type = string
}

variable "public_cidr" {
  type = list(string)
}

variable "frontend_cidr" {
  type = list(string)
}

variable "backend_cidr" {
  type = list(string)
}

variable "db_cidr" {
  type = list(string)
}

variable "availability_zone" {
  type = list(list(string))
}

variable "region" {
  type = string
}

variable "project_name" {
  type = string
}

variable "env" {
  type = string
}

variable "internet_gateway_yn" {
  type    = bool
  default = true
}



variable "bastion_ec2_auto_on_off" {
  type    = bool
  default = false
}

variable "endpoint_ingress_rules" {
  type    = list(tuple([string, string, string, list(string), string]))
  default = []
}

variable "bastion_ingress_rules" {
  type    = list(tuple([string, string, string, list(string), string]))
  default = []
}

variable "frontend_subnet_sg_yn" {
  type    = bool
  default = false
}

variable "backend_subnet_sg_yn" {
  type    = bool
  default = false
}

variable "db_subnet_sg_yn" {
  type    = bool
  default = false
}

variable "frontend_internet_yn" {
  type    = bool
  default = false
}


variable "backend_internet_yn" {
  type    = bool
  default = false
}

variable "frontend_bastion_yn" {
  type    = bool
  default = false
}

variable "backend_bastion_yn" {
  type    = bool
  default = false
}

variable "db_bastion_yn" {
  type    = bool
  default = false
}

variable "transit_gateway_cidr" {
  type    = list(any)
  default = []
}

variable "transit_gateway_id" {
  type    = string
  default = ""
}

variable "tags" {
  type    = map(string)
  default = {}
}
