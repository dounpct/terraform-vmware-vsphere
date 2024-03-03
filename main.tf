provider "vsphere" {
  user                 = var.vsphere_user
  password             = var.vsphere_password
  vsphere_server       = var.vsphere_server
  allow_unverified_ssl = true
}

data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  count = var.vsphere_datastore != null ? 1 : 0
  name = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_datastore_cluster" "datastore_cluster" {
  count = var.vsphere_datastore_cluster != null ? 1 : 0
  name          = var.vsphere_datastore_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}
data "vsphere_compute_cluster" "cluster" {
  name = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name = var.vsphere_pool
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_network" "network" {
  count         = length(var.vsphere_network)
  name          = var.vsphere_network[count.index]
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name = var.virtual_template
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name             = each.key
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_cluster_id = length(data.vsphere_datastore_cluster.datastore_cluster) == 1 ? data.vsphere_datastore_cluster.datastore_cluster[0].id : null   
  datastore_id     = length(data.vsphere_datastore.datastore) == 1 ? data.vsphere_datastore.datastore[0].id : null

  num_cpus         = var.vm_cpu
  memory           = var.vm_memory
  guest_id         = data.vsphere_virtual_machine.template.guest_id
  scsi_type        = data.vsphere_virtual_machine.template.scsi_type
  firmware         = data.vsphere_virtual_machine.template.firmware

  scsi_controller_count  = var.scsi_controller_count != "" ? var.scsi_controller_count : "1"

  cpu_hot_add_enabled = true
  memory_hot_add_enabled = true

  wait_for_guest_net_timeout = 0
  wait_for_guest_ip_timeout  = 0

  dynamic "network_interface" {
    for_each = data.vsphere_network.network
    content {
      network_id   = network_interface.value.id
      adapter_type = data.vsphere_virtual_machine.template.network_interface_types[0]
    }
  }
  
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id
    customize {
      linux_options {
        host_name = each.key
        domain    = var.host_domain
      }

      dynamic "network_interface" {
        for_each = [for i in range(length(var.virtual_machines[each.key]["ip"])) : { 
          ip: var.virtual_machines[each.key]["ip"][i], 
          netmask: var.virtual_machines[each.key]["netmask"][i]
        }]

        content {
          ipv4_address = network_interface.value.ip
          ipv4_netmask = network_interface.value.netmask
        }
      }
      
      ipv4_gateway = var.network_gateway
      dns_server_list = var.dns_server_list
    }
  }
  
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks.0.size
    thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned
  }
  
  dynamic "disk" {
    for_each = var.extra_disk_list
    content {
      label            = disk.key
      size             = disk.value.size
      thin_provisioned = data.vsphere_virtual_machine.template.disks.0.thin_provisioned    
      unit_number      = disk.value.unit_number
    }
  }

  # provisioner "file" {
  #   # Copy install scripts.
  #   source      = "./setup-scripts/"
  #   destination = "/home/root/"
  #   on_failure = fail
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "echo '${var.vm_password}' | sudo -S pwd",
  #     "ls -alrt",
  #     "chmod +x /home/root/*.bash",
  #     "sudo /home/root/extend-swap.bash",
  #     "sudo /home/root/extend-data.bash",
  #   ]
  #   on_failure = fail
  # }

  # connection {
  #   type     = "ssh"
  #   user     = var.vm_user
  #   password = var.vm_password
  #   host     = each.value.ip
  #   script_path = "/home/root/remote.bash"
  # }
  
}
