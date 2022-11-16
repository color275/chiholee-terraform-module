variable "name" {
  type    = string
}

variable policy {
  type = string
  default = ""
}

variable tags {
  type = map(string)
  default = {}
}