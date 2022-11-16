variable vpc_yn {
  type = bool
  default = false
}

variable vpc_id {
  type = string
  default = ""
}

variable subnet_ids {
  type = list
  default = []
}

variable security_group_ids {
  type = list
  default = []
}

variable description {
  type = string
}

variable function_name {
  type = string
}

variable path {
  type = string
  default = ""
}

variable role {
  type = string
}

variable handler {
  type = string
}

variable runtime {
  type = string
}

variable memory_size {
  type = number
  default = null
}

variable timeout {
  type = number
  default = 60
}

variable environment {
  type = map
  default = {}
}

variable tags   {
  type = map
  default = {}
}


variable retention_in_days {
  type = number
  default = null
}

variable zip_yn {
  type = bool
  default = true
}

variable image_yn {
  type = bool
  default = false
}

variable image_uri {
  type = string
  default = ""
}

variable package_type {
  type = string
  default = "Zip"
}

# variable output_path {
#   type = string
# }
