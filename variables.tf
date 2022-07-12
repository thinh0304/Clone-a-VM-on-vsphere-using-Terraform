variable "vsphere_user" {
  default = "thinhnt@terabox.local"
}
variable "vsphere_password" {
  default = "Terabox@@123"
}
variable "vsphere_datacenter"{
  default = "vcsa.terabox.local"
}
variable "vsphere_datastore"{
  default = "SAN01 - VeeamCC only"
}
variable "vsphere_resource_pool"{
  default = "DevOps Test"
}
variable "vsphere_host"{
  default = "esxi01.terabox.local"
}
variable "vsphere_network"{
  default = "DHCP Network"
}
variable "vsphere_server" {
  default = "vcsa.terabox.local"
}
variable "vm_user"{
  default = "root"
}
variable "vm_password"{
  default = "Terabox@@123"
}

variable "vsphere_vm_firmware" {
  description = "Firmware set to bios or efi depending on Template"
  default = "efi"
}