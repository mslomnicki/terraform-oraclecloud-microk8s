resource "oci_core_vcn" "vcn_kube" {
  cidr_block     = var.vcn_cidr
  compartment_id = var.compartment_ocid
  display_name   = "vcn-kube"
  dns_label      = "kubevcn"
  is_ipv6enabled = false
}

resource "oci_core_subnet" "subnet_kube" {
  cidr_block     = var.subnet_cidr
  compartment_id = var.compartment_ocid
  display_name   = "subnet-kube"
  dns_label      = "kube"
  # prohibit_internet_ingress  = "false"
  # prohibit_public_ip_on_vnic = "false"
  vcn_id            = oci_core_vcn.vcn_kube.id
  security_list_ids = [oci_core_vcn.vcn_kube.default_security_list_id]
  route_table_id    = oci_core_vcn.vcn_kube.default_route_table_id
  dhcp_options_id   = oci_core_vcn.vcn_kube.default_dhcp_options_id
}

resource "oci_core_internet_gateway" "ig_kube" {
  compartment_id = var.compartment_ocid
  display_name   = "Internet Gateway for k8s"
  enabled        = "true"
  vcn_id         = oci_core_vcn.vcn_kube.id
}

resource "oci_core_default_route_table" "rt_default_kube" {
  compartment_id             = var.compartment_ocid
  display_name               = "Default Route Table for vcn_kube"
  manage_default_resource_id = oci_core_vcn.vcn_kube.default_route_table_id
  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.ig_kube.id
  }
}

resource "oci_core_default_security_list" "seclist_kube" {
  compartment_id = var.compartment_ocid
  display_name   = "Default Security List for vcn_kube"
  egress_security_rules {
    description      = "[ALL] Allow all traffic going out"
    destination      = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    protocol         = "all"
    stateless        = "false"
  }
  ingress_security_rules {
    description = "[ALL] Allow SSH"
    protocol    = "6"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
    tcp_options {
      max = "22"
      min = "22"
    }
  }
  ingress_security_rules {
    description = "[ALL] Allow ICMP fragmentation packets"
    icmp_options {
      code = "4"
      type = "3"
    }
    protocol    = "1"
    source      = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  ingress_security_rules {
    description = "[SUBNET] Allow ICMP destination unreachable packets"
    icmp_options {
      type = "3"
    }
    protocol    = "1"
    source      = var.subnet_cidr
    source_type = "CIDR_BLOCK"
    stateless   = "false"
  }
  ingress_security_rules {
    description = "[MGMT] Allow all traffic"
    protocol    = "all"
    source      = var.mgmt_address
    source_type = "CIDR_BLOCK"
    stateless   = "true"
  }
  manage_default_resource_id = oci_core_vcn.vcn_kube.default_security_list_id
}

