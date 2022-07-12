
terraform {
  required_providers {
    vsphere = {
      source = "hashicorp/vsphere"
      version = "2.1.1"
    }
  }
}
provider "vsphere" {
  user           = var.vsphere_user
  password       = var.vsphere_password
  vsphere_server = var.vsphere_server

  # If you have a self-signed cert
  allow_unverified_ssl = true
}

#add name DC, name disk, name cluster, name host, name network, name pool
data "vsphere_datacenter" "dc" {
  name = var.vsphere_datacenter
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.dc.id
}

data "vsphere_resource_pool" "pool" {
  name          = var.vsphere_resource_pool
  datacenter_id = data.vsphere_datacenter.dc.id
}
/*data "vsphere_host" "host"{
  name          = "esxi01.terabox.local"
  datacenter_id = data.vsphere_datacenter.dc.id
}*/
data "vsphere_network" "network"{
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.dc.id
}
data "vsphere_virtual_machine" "win2019" {
  name          = "WIN2019"
  datacenter_id = data.vsphere_datacenter.dc.id
}

##Trying create folder in vcenter
resource "vsphere_folder" "folder" {
  path          = "terraform-test-folder"
  type          = "vm"
  datacenter_id = data.vsphere_datacenter.dc.id
}
/*
data "template_file" "userdata_win" {
  template = <<EOF
<script>
mkdir C:\Users\Administrator\setup-scripts
cd C:\Users\Administrator\se tup-scripts
echo "" > _INIT_STARTED_
echo ${base64encode(file("${path.module}/userdata_win.bat"))} > tmp1.b64 && certutil -decode tmp1.b64 userdata.bat
echo ${base64encode(file("${path.module}/config.json"))} > tmp2.b64 && certutil -decode tmp2.b64 config.json
${file("${path.module}/userdata_win.bat")}
echo "" > _INIT_COMPLETE_
</script>
<persist>false</persist>
EOF
}
*/
resource "vsphere_virtual_machine" "vm" {
  name             = "win2019test"
  //host_system_id   = data.vsphere_host.host.id //remove?
  resource_pool_id = data.vsphere_resource_pool.pool.id
  datastore_id     = data.vsphere_datastore.datastore.id
  num_cpus         = 2
  memory           = 4096
  guest_id         = data.vsphere_virtual_machine.win2019.guest_id
  scsi_type        = data.vsphere_virtual_machine.win2019.scsi_type
  firmware         = "${var.vsphere_vm_firmware}"
  folder           = "terraform-test-folder"
  //user_data = data.template_file.userdata_win.rendered

  network_interface {
    network_id   = data.vsphere_network.network.id
    adapter_type = "e1000e"
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.win2019.disks.0.size
    thin_provisioned = true
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.win2019.id
    customize {
      windows_options {
        computer_name   = "thinhwin2019"
        admin_password  = "Terabox@@123"
        auto_logon = true

      }
      network_interface {
        ipv4_address = "192.168.99.68"
        ipv4_netmask = 24
        dns_server_list = ["192.168.99.1","8.8.8.8"]
  
      }
      ipv4_gateway = "192.168.99.1"
    }
    
  }
  /*connection {
      host = "192.168.99.130"
      type = "ssh"
      user = "${var.vm_user}"
      password = "${var.vm_password}"
      agent = false
    

      
    }
    
    provisioner "file" {
      source      = "thinh.txt"
      destination = "C:/thinh.txt"
    }*/
  /*provisioner "file" {
    source      = "thinh.txt"
    destination = "C:/thinh.txt"

    connection {
      host     = "192.168.99.161"
      port     = "5985"
      timeout  = "3m"
      type     = "winrm"
      user     = "Administrator"
      password = "Terabox@@123"
      https    = false
      insecure = true
      use_ntlm = false
    

    

    }
  }*/
 
    
}


 
