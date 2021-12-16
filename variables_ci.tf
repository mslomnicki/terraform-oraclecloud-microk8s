variable "vm_image_ocid" {
  type = map(string)

  default = {
    # See https://docs.us-phoenix-1.oraclecloud.com/images/
    # Oracle-provided image "Canonical-Ubuntu-20.04-aarch64-2021.10.15-0"
    eu-frankfurt-1 = "ocid1.image.oc1.eu-frankfurt-1.aaaaaaaapzfowmk3dwyurhox53yx4eqkmwourxs2ujxgykiymgsw4xnmmkya"
  }
}

variable "volume_size" {
  default = "40" #GB
}

variable "vm_count" {
  default = 1
}
