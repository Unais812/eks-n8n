locals {
  subnets = {
    "public-1"  = { cidr = "10.0.1.0/24", az = "eu-north-1a", public = true  }
    "private-1" = { cidr = "10.0.2.0/24", az = "eu-north-1a", public = false }
    "public-1"  = { cidr = "10.0.3.0/24", az = "eu-north-1b", public = true  }
    "private-1" = { cidr = "10.0.4.0/24", az = "eu-north-1b", public = false }
    }   
}

locals {
    name = "ECSv3"
}