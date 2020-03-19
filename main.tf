
//resource "azurerm_resource_group" "k8s" {
//  name     = var.resource_group_name
//  location = var.location
//}

data "azurerm_resource_group" "k8s" {
  name = var.resource_group_name
}

resource "azurerm_kubernetes_cluster" "k8s" {
  name                = var.cluster_name
  location            = data.azurerm_resource_group.k8s.location
  resource_group_name = data.azurerm_resource_group.k8s.name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kube_version

  linux_profile {
    admin_username = var.admin_username

    ssh_key {
      key_data = file(var.ssh_public_key)
    }
  }
  default_node_pool {
    name            = "default"
    node_count      = var.agent_count
    vm_size         = var.azurek8s_sku
    os_disk_size_gb = 30
  }

  //  agent_pool_profile {
  //    name            = "default"
  //    count           = var.agent_count
  //    vm_size         = var.azurek8s_sku
  //    os_type         = "Linux"
  //    os_disk_size_gb = 30
  //  }

   service_principal {
     client_id     = var.client_id
     client_secret = var.client_secret
   }
}


//resource "azurerm_storage_account" "acrstorageacc" {
//  name                     = "${var.resource_storage_acct}"
//  resource_group_name      = "${azurerm_resource_group.k8s.name}"
//  location                 = "${azurerm_resource_group.k8s.location}"
//  account_tier             = "Standard"
//  account_replication_type = "GRS"
//}

resource "azurerm_container_registry" "acrtest" {
  name                = var.azure_container_registry_name
  location            = data.azurerm_resource_group.k8s.location
  resource_group_name = data.azurerm_resource_group.k8s.name
  admin_enabled       = true
  sku                 = "Premium"

  // storage_account_id  = "${azurerm_storage_account.acrstorageacc.id}"
}
