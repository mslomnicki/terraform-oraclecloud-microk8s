variable "compartment_ocid" {
  description = "OCID from your tenancy page"
  type        = string
}

variable "region" {
  description = "OC region"
  type        = string
}

variable "profile" {
  description = "OCI auth profile"
  type        = string
  default     = "terraform"
}

variable "vcn_cidr" {
  description = "VCN network CIDR"
  type        = string
}

variable "subnet_cidr" {
  description = "Subnet network CIDR"
  type        = string
}

variable "mgmt_address" {
  description = "Management address (allow all traffic)"
  type        = string
}

variable "ssh_key" {
  type = string
}

