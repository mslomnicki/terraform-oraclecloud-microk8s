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

