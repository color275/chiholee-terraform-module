variable "parameter_list" {
  type        = list(tuple([string,string,string]))
  default = []
}

variable "kms_key_id" {
  type = string
}