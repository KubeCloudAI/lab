provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "sachin_aks" {
  name     = "${var.prefix}-k8s-resources"
  location = var.location
}

resource "azurerm_kubernetes_cluster" "sachin_aks" {
  name                = "${var.prefix}-k8s"
  location            = azurerm_resource_group.sachin
_aks.location
  resource_group_name = azurerm_resource_group.sachin
_aks.name
  dns_prefix          = "${var.prefix}-k8s"
  kubernetes_version  = "1.23.12"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_DS2_v2"
  }

  identity {
    type = "SystemAssigned"
  }
}

# resource "azurerm_container_registry" "sachin_aks" {
#   name                = "${var.prefix}sachink8sregistry"
#   resource_group_name = azurerm_resource_group.sachin_aks.name
#   location            = azurerm_resource_group.sachin_aks.location
#   sku                 = "Standard"
# }

# resource "azurerm_role_assignment" "sachin_aks" {
#   principal_id                     = azurerm_kubernetes_cluster.sachin_aks.kubelet_identity[0].object_id
#   role_definition_name             = "AcrPull"
#   scope                            = azurerm_container_registry.sachin_aks.id
#   skip_service_principal_aad_check = true
# }