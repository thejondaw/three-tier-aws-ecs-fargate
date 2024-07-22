# --- --- --- --- --- --- --- --- --- --- #

# Configure AWS Provider
variable "region" {
  description = "Please provide a region information"
  type        = string
  default     = ""
}

# --- --- --- --- --- --- --- --- --- --- #

# Variable for Backend
variable "bucket" {
  description = "The name of the S3 bucket to store Terraform state"
  type        = string
  default     = "mrjondaw"
}

# --- --- --- --- --- --- --- --- --- --- #