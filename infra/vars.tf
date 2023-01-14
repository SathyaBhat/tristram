variable "bucket_name" {
  type    = string
  default = "tristram-backup"
}

variable "user_name" {
  type    = string
  default = "restic"
}

variable "policy_name" {
  type    = string
  default = "restic"
}
