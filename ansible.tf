resource "null_resource" "ansible_setup" {
  depends_on = [
    oci_core_instance.ci_k8s,
    oci_network_load_balancer_network_load_balancer.nlb_kube
  ]
  count = var.vm_count

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = oci_core_instance.ci_k8s[count.index].public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_filename)
    }
    script = "userdata/ansible_setup.sh"
  }
}

resource "null_resource" "ansible_exec" {
  triggers = {
    key = "${uuid()}"
  }

  depends_on = [
    oci_core_instance.ci_k8s,
    null_resource.ansible_setup
  ]
  count = var.vm_count

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = oci_core_instance.ci_k8s[count.index].public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_filename)
    }
    inline = [
      "mkdir -p ~/ansible"
    ]
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      host        = oci_core_instance.ci_k8s[count.index].public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_filename)
    }
    source      = "userdata/ansible.yaml"
    destination = "ansible/ansible.yaml"
  }

  provisioner "file" {
    connection {
      type        = "ssh"
      host        = oci_core_instance.ci_k8s[count.index].public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_filename)
    }
    source      = "userdata/ansible_exec.sh"
    destination = "ansible/ansible_exec.sh"
  }

  provisioner "remote-exec" {
    connection {
      agent       = false
      timeout     = "30m"
      host        = oci_core_instance.ci_k8s[count.index].public_ip
      user        = "ubuntu"
      private_key = file(var.ssh_private_key_filename)
    }
    inline = [
      "/bin/bash ~/ansible/ansible_exec.sh ${oci_core_instance.ci_k8s[count.index].private_ip} ${oci_core_instance.ci_k8s[count.index].public_ip} ${var.subnet_cidr} ${var.mgmt_address} ${local.nlb_public_ip}"
    ]
  }
}

