#########################################
## cicd
#########################################
variable app_name {
  type = string
}

variable service_name {
  type = string
}

variable action_on_timeout {
  type = string
  default = "STOP_DEPLOYMENT"
}

variable wait_time_in_minutes {
  type = number
  default = 5
}

variable build_timeout {
  type = number
  default = 30
}


variable codecommit_repository_description {
  type = string
}

variable source_bucket_name {
  type = string
}

variable kms_arn {
  type = string
}

variable codebuild_cache_bucket {
  type = string
  default = null
}

variable vpc_yn {
  type = bool
  default = false
}

variable vpc_id {
  type = string
  default = null
}

variable subnets {
  type = list
  default = null
}

variable security_group_ids {
  type = list
  default = null
}

# BUILD_GENERAL1_SMALL
# BUILD_GENERAL1_MEDIUM
# BUILD_GENERAL1_LARGE
# BUILD_GENERAL1_2XLARGE
variable codebuild_compute_type {
  type = string
  default = "BUILD_GENERAL1_SMALL"
}


##########################################
## account
##########################################
variable "account_id" {
  type = string
}

variable dev_account_id {
  type = string
}

variable test_account_id {
  type = string
}

variable prod_account_id {
  type = string
}

variable region {
  type        = string
}

# ##########################################
# ## deploy
# ##########################################


variable test_approval {
  type = bool
  default = false
}

variable prod_approval {
  type = bool
  default = false
}

variable sns_arn {
  type = string
  default = null
}

variable tags {
  type = map(string)
  default = {}
}

variable lambda_exec_role_name {
  type = string
  default = ""
}

variable lambda_name {
  type = string
  default = ""
}

variable repo_name {
  type = string
  default = ""
}

variable update_lambda_name {
  type = string
  default = ""
}