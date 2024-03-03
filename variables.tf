
variable "vsphere_server" {
  description = "vCenter server FQDN or IP - Example: vcsa01-z67.sddc.lab"
}

variable "vsphere_user" {
  description = "vSphere username to use to connect to the environment - Default: administrator@vsphere.local"
}

variable "vsphere_password" {
  description = "vSphere password"
}

variable "vsphere_datacenter" {
  description = "vSphere datacenter"
}
variable "vsphere_datastore" {
  description = "vSphere datastore"
}
variable "vsphere_datastore_cluster" {
  description = "vSphere datastore cluster"
}
variable "vsphere_cluster" {
  description = "vSphere cluster"
}
variable "vsphere_pool" {
  description = "vSphere pool"
}

variable "dns_server_list" {
  type    = list
}

variable "virtual_template" {
  description = "virtual template"
}

variable "virtual_machines" {
  type = map(object({
    ip = list(string),
    netmask = list(string),
  }))
}

variable "vm_cpu" {
  description = "vm cpu"
}
variable "vm_memory" {
  description = "vm memory"
}
variable "network_gateway" {
  description = "network gateway"
}
variable "host_domain" {
  description = "host domain"
}
variable "vm_user" {
  description = "vm user for run script"
}
variable "vm_password" {
  description = "vm password for run script"
}

variable "scsi_controller_count" {
  description = "vm pscsi_controller_count"
}

variable "extra_disk_list" {
  type = map(object({
    size = string
    unit_number = string
  }))
}

variable "vsphere_network" {
  description = "List of network names"
  type        = list(string)
  default     = ["NETWORK_1", "NETWORK_2"]
}