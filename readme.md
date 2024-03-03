
# run terraform
    terraform init

# inject env
    vsphere_password=<vsphere_password>
    vm_password=<vm_password>
# run plan for recheck
    terraform plan -var=vsphere_password=${vsphere_password} -var=vm_password=${vm_password}

# run apply 
    terraform apply -var=vsphere_password=${vsphere_password} -var=vm_password=${vm_password}
    
    terraform apply -var=vsphere_password=${vsphere_password} -var=vm_password=${vm_password} -var="scsi_controller_count=4" -var='virtual_machines={"D2D-VM-02"={"ip"="10.100.100.25"}}'

    terraform apply -var=vsphere_password=${vsphere_password} -var=vm_password=${vm_password} -var="scsi_controller_count=4" -var-file="./vm.tfvars"    -var=extra_disk_list'={disk2={size="60",unit_number="15"}}'

    terraform apply -var=vsphere_password=${vsphere_password} -var=vm_password=${vm_password} -var="scsi_controller_count=4" -auto-approve

    terraform apply -var="scsi_controller_count=4" -var-file="./vm.tfvars" -var-file="/Users/sutee.kon/Desktop/d/ext-vm.tfvars"
# delete resource
    
    terraform destroy -var=vsphere_password=${vsphere_password} -var=vm_password=${vm_password}

