variable "version-k8s" {
  description = "version of k8s"
  type        = string
  default     = "1.36"
}

variable "vpc-id" {
  description = "id of the vpc for cluster"
  type        = string
}

variable "ami" {
  description = "ami for the node groups"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "instance-type" {
  description = "instance type for the node groups"
  type        = string
  default     = "t3.medium"
}

variable "desired-size" {
  description = "desired amount of node groups"
  type        = number
  default     = 1
}

variable "max-size" {
  description = "max amount of node groups"
  type        = number
  default     = 1
}

variable "min-size" {
  description = "minimum amount of node groups"
  type        = number
  default     = 1
}

variable "region" {
  description = "region to include for cloudwatch"
  type        = string
  default     = "eu-north-1"
}

variable "vpc-cni-role" {
  description = "role for the vpc cni pod identity agent"
  type = string
}

variable "private-subnets" {
  description = "the ids of the private subnets"
}

variable "eks-node-group-role" {
  description = "iam role of the eks node group"
  type = string
}