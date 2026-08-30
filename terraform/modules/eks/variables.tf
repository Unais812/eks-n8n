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

variable "private-subnet-1" {
  description = "id of private subnet"
  type = string
}

variable "private-subnet-2" {
  description = "id of private subnet"
  type = string
}

variable "eks-node-group-role" {
  description = "iam role of the eks node group"
  type = string
}

variable "eks-cluster-role" {
  description = "role of the eks cluster"
  type = string
}

variable "eks-role-attachment" {
  description = "policy attachment for the depends on in eks cluster config"
}

variable "node-group-ec2-attachment" {
  description = "policy attachment for the depends on argument for node group"
}

variable "node-group-ecr-attachment" {
  description = "policy attachment for the depends on argument for node group"
}

variable "ebs_csi_driver_role_arn" {
  description = "IAM role ARN used by the EFS CSI controller through EKS Pod Identity"
  type        = string
}