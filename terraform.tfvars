vsphere_server      = "111.111.111.111"
vsphere_user        = "robot@vsphere.local"

vsphere_datacenter  = "DC01"

vsphere_datastore   = "DS99_D2D_APP"
vsphere_datastore_cluster = null

vsphere_cluster     = "TTT-NON-PROD"
vsphere_pool        = "AUTOMATION"

virtual_template    = "GoldenImageOracle8.5"
vm_cpu              = "4"
vm_memory           =  "8192"
network_gateway     = "10.10.10.254"
host_domain         = ""
vm_user         = "root"
dns_server_list = ["12.10.10.1","12.10.10.2"]

vsphere_network = ["TTT_SERVICE_01","TTT_MANAGE_01"]
virtual_machines = {
    VM-AUTOMATION-01 = {
      ip = ["10.10.10.15","10.200.10.15"],
      netmask = ["24","24"]
    },
  }

extra_disk_list = {
  disk1 = {
      size = "8",
      unit_number = "1",
  },
  disk2 = {
      size = "16",
      unit_number = "2",
  },
  disk3 = {
      size = "50"
      unit_number = "3"
  },
}