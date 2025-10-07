variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "location" {
  description = "Region Zone"
  type        = string
}

variable "cluster_name" {
  description = "GKE cluster name"
  type        = string
}

variable "network" {
  description = "VPC name or self_link"
  type        = string
}

variable "subnetwork" {
  description = "Subnet name or self_link"
  type        = string
}

variable "release_channel" {
  description = "GKE release channel (RAPID, REGULAR, STABLE)"
  type        = string
  default     = "REGULAR"
}

variable "enable_workload_identity" {
  description = "It enables the Workload Identity feature on Cluster and Node Pools"
  type        = bool
  default     = true
}

# Node Pool
variable "node_count" {
  description = "Node count (if the autoscaling is enabled)"
  type        = number
  default     = 1
}

variable "enable_np_autoscaling" {
  description = "It enable the Node Pool autoscaling"
  type        = bool
  default     = true
}

variable "min_node_count" {
  description = "Node Pool min node count"
  type        = number
  default     = 1
}

variable "max_node_count" {
  description = "Node Pool max node count"
  type        = number
  default     = 3
}

variable "machine_type" {
  description = "Node Pool machine type"
  type        = string
  default     = "e2-standard-4"
}

variable "disk_size_gb" {
  description = "Node Pool disk size"
  type        = number
  default     = 100
}

variable "disk_type" {
  description = "Node Pool disk type (pd-standard, pd-balanced, pd-ssd)"
  type        = string
  default     = "pd-balanced"
}

variable "image_type" {
  description = "Node Pool image type (COS_CONTAINERD, UBUNTU_CONTAINERD)"
  type        = string
  default     = "COS_CONTAINERD"
}

variable "node_service_account" {
  description = "Node Pool Service Account. If null, it will use the Project's default."
  type        = string
  default     = null
}

variable "oauth_scopes" {
  description = "Node Pool OAuth scopes"
  type        = list(string)
  default = [
    "https://www.googleapis.com/auth/cloud-platform"
  ]
}

variable "node_labels" {
  description = "Node Pool additional labels"
  type        = map(string)
  default     = {}
}

variable "node_tags" {
  description = "Node Pool network tags"
  type        = list(string)
  default     = []
}

variable "node_metadata" {
  description = "Node Pool additional metadata"
  type        = map(string)
  default     = {}
}

# Logging/Monitoring
variable "logging_components" {
  description = "GKE logging components"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "WORKLOADS", "APISERVER"]
}

variable "monitoring_components" {
  description = "GKE monitoring components"
  type        = list(string)
  default     = ["SYSTEM_COMPONENTS", "APISERVER"]
}

variable "maintenance_start_time" {
  description = "Maintenance start time (RFC3339)"
  type        = string
  default     = "2025-10-05T00:00:00Z"
}

variable "maintenance_end_time" {
  description = "Maintenance end time (RFC3339)"
  type        = string
  default     = "2025-10-05T06:00:00Z"
}

variable "maintenance_recurrence" {
  description = "Maintenance recurrence"
  type        = string
  default     = "FREQ=WEEKLY;BYDAY=SU,WE"
}



variable "enable_private_cluster" {
  description = "Whether to enable a private (internal) cluster"
  type        = bool
  default     = true
}

variable "enable_private_endpoint" {
  description = "Whether to expose the master endpoint internally only"
  type        = bool
  default     = false
}

variable "master_ipv4_cidr_block" {
  description = "CIDR block for GKE master in private clusters"
  type        = string
  default     = "172.16.0.0/28"
}

variable "pods_range_name" {
  description = "Secondary IP range name for pods"
  type        = string
  default     = null
}

variable "services_range_name" {
  description = "Secondary IP range name for services"
  type        = string
  default     = null
}

variable "authorized_cidr_blocks" {
  description = "List of CIDRs allowed to connect to GKE master (used for private clusters)"
  type = list(object({
    name = string
    cidr = string
  }))
  default = []
}
