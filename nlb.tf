resource "oci_network_load_balancer_network_load_balancer" "nlb_kube" {
  display_name   = "Kubernetes Network Load Balancer"
  compartment_id = var.compartment_ocid
  subnet_id      = oci_core_subnet.subnet_kube.id
  is_private     = false
}

locals {
  nlb_public_ip = [for v in oci_network_load_balancer_network_load_balancer.nlb_kube.ip_addresses : v if v.is_public][0].ip_address
}

output "nlb_public_ip" {
  description = "Public IP address of Network Load Balancer"
  value       = local.nlb_public_ip
}

resource "oci_network_load_balancer_backend_set" "nlb_bs_api" {
  name                     = "k8s-api"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol           = "HTTPS"
    timeout_in_millis  = 3000
    interval_in_millis = 10000
    retries            = 3
    url_path           = "/"
    return_code        = 401
  }
}

resource "oci_network_load_balancer_backend" "nlb_b_api" {
  count                    = var.vm_count
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_bs_api.name
  ip_address               = oci_core_instance.ci_k8s[count.index].private_ip
  port                     = 16443
  is_backup                = false
  is_drain                 = false
  is_offline               = false
  weight                   = 1
}

resource "oci_network_load_balancer_listener" "nlb_listener_api" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  name                     = "API listener"
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_bs_api.name
  port                     = 16443
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "nlb_bs_http" {
  name                     = "k8s-http"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol           = "HTTP"
    timeout_in_millis  = 3000
    interval_in_millis = 10000
    retries            = 3
    url_path           = "/"
    return_code        = 404
  }
}

resource "oci_network_load_balancer_backend" "nlb_b_http" {
  count                    = var.vm_count
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_bs_http.name
  ip_address               = oci_core_instance.ci_k8s[count.index].private_ip
  port                     = 80
  is_backup                = false
  is_drain                 = false
  is_offline               = false
  weight                   = 1
}

resource "oci_network_load_balancer_listener" "nlb_listener_http" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  name                     = "HTTP listener"
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_bs_http.name
  port                     = 80
  protocol                 = "TCP"
}

resource "oci_network_load_balancer_backend_set" "nlb_bs_https" {
  name                     = "k8s-https"
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  policy                   = "FIVE_TUPLE"

  health_checker {
    protocol           = "HTTPS"
    timeout_in_millis  = 3000
    interval_in_millis = 10000
    retries            = 3
    url_path           = "/"
    return_code        = 404
  }
}

resource "oci_network_load_balancer_backend" "nlb_b_https" {
  count                    = var.vm_count
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  backend_set_name         = oci_network_load_balancer_backend_set.nlb_bs_https.name
  ip_address               = oci_core_instance.ci_k8s[count.index].private_ip
  port                     = 443
  is_backup                = false
  is_drain                 = false
  is_offline               = false
  weight                   = 1
}

resource "oci_network_load_balancer_listener" "nlb_listener_https" {
  network_load_balancer_id = oci_network_load_balancer_network_load_balancer.nlb_kube.id
  name                     = "HTTPS listener"
  default_backend_set_name = oci_network_load_balancer_backend_set.nlb_bs_https.name
  port                     = 443
  protocol                 = "TCP"
}

