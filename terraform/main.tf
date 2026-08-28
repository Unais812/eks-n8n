module "eks" {
  source = "./modules/eks"
  vpc-id = module.vpc.vpc_id
  eks-node-group-role = module.iam.eks-node-group-role
  private-subnets = module.vpc.private_subnet_ids
  vpc-cni-role = module.iam.vpc-cni-role
}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}