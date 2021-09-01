packer {
  required_plugins {
    azure = {
      version = ">= 1.0.0"
      source  = "github.com/hashicorp/azure"
    }
  }
}
source "azure-arm" "CentOS" {
  azure_tags = {
    Owner = "i.giannakopoulos"
    task  = "Image deployment"
  }
  client_id                         = "${var.client_id}"
  client_secret                     = "${var.client_secret}"
  image_offer                       = "CentOS"
  image_publisher                   = "OpenLogic"
  image_sku                         = "7_9-gen2"
  location                          = "West Europe"
  managed_image_name                = "myPackerImageDEMO"
  managed_image_resource_group_name = "iac-rg"
  os_type                           = "Linux"
  subscription_id                   = "${var.subscription_id}"
  tenant_id                         = "${var.tenant_id}"
  vm_size                           = "Standard_DS2_v2"
}

build {
  sources = ["source.azure-arm.CentOS"]

  provisioner "shell" {
    inline          = [ "sudo yum -y install epel-release"]
  }
  
    provisioner "shell"  {
    inline          = [ "sudo yum -y install nginx htop nmon", "sudo yum -y update"]
  }
    provisioner "shell"  {
    inline          = [ "sudo timedatectl set-timezone Europe/Athens"]
  }
    provisioner "shell"  {
    inline          = ["sudo /usr/sbin/waagent -force -deprovision+user && export HISTSIZE=0 && sync"]
  }
}

variable "client_id" {
  type    = string
}

variable "client_secret" {
 type = string
}

variable "subscription_id" {
 type = string
}

variable "tenant_id" {
 type = string
}

