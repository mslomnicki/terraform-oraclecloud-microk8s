resource "oci_core_instance" "ci_k8s" {
  count               = var.vm_count
  availability_domain = data.oci_identity_availability_domain.ad3.name
  compartment_id      = var.compartment_ocid
  display_name        = "TFKube_${count.index + 1}"
  shape               = var.instance_shape

  shape_config {
    ocpus         = var.instance_ocpus
    memory_in_gbs = var.memory_size
  }

  create_vnic_details {
    subnet_id                 = oci_core_subnet.subnet_kube.id
    display_name              = "Primaryvnic"
    assign_public_ip          = true
    assign_private_dns_record = true
    hostname_label            = "tfkube${count.index + 1}"
  }

  source_details {
    source_type = "image"
    source_id   = var.vm_image_ocid[var.region]
  }

  metadata = {
    ssh_authorized_keys = var.ssh_key
    #    user_data           = base64encode(file("./userdata/bootstrap"))
  }

  timeouts {
    create = "60m"
  }
}

