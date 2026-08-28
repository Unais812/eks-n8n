locals {
  subnets = {
    "public-1"  = { cidr = "10.0.1.0/24", az = "eu-north-1a", public = true  }
    "private-1" = { cidr = "10.0.3.0/24", az = "eu-north-1a", public = false }
    }   
}

locals {
    name = "ECSv3"
}