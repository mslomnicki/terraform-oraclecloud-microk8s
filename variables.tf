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

variable "ssh_private_key_filename" {
  description = "Location of SSH private key"
  type        = string
}

variable "vm_image_ocid" {
  type = map(string)

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Canonical-Ubuntu-20.04-aarch64"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaa6ueulrtedgclrxznl5pkzhzseddl7b6iq6jhdl3vjm62zhddpxta"
  }
}

variable "vm_count" {
  default = 4
}

variable "instance_shape" {
  default = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  default = 1
}

variable "memory_size" {
  default = 6
}

