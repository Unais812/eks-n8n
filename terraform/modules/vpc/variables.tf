variable "vpc_cidr" {
  description = "vpc cidr"
  type = string
  default = "10.0.0.0/16"
}

variable "region" {
  description = "region"
  type = string
  default = "eu-north-1"
}

variable "public_cidr" {
  description = "cidr for public traffic"
  type = string
  default = "0.0.0.0/0"
}

variable "public-subnet-1-cidr" {
  type = string
  default = "10.0.1.0/24"
}

variable "private-subnet-1-cidr" {
  type = string
  default = "10.0.2.0/24"
}

variable "public-subnet-2-cidr" {
  type = string
  default = "10.0.3.0/24"
}

variable "private-subnet-2-cidr" {
  type = string
  default = "10.0.4.0/24"
}

variable "az1" {
  type = string
  default = "eu-north-1a"
}

variable "az2" {
  type = string
  default = "eu-north-1b"
}