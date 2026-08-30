module "eks" {
  source = "./modules/eks"
  vpc-id = module.vpc.vpc_id
  eks-node-group-role = module.iam.eks-node-group-role
  vpc-cni-role = module.iam.vpc-cni-role
  eks-cluster-role = module.iam.eks-cluster-role
  eks-role-attachment = module.iam.eks-role-attachment
  node-group-ec2-attachment = module.iam.node-group-ec2-attachment
  node-group-ecr-attachment = module.iam.node-group-ecr-attachment
  private-subnet-1 = module.vpc.private-subnet-1
  private-subnet-2 = module.vpc.private-subnet-2
  ebs_csi_driver_role_arn     = module.iam.ebs_csi_driver_role_arn

}

module "vpc" {
  source = "./modules/vpc"
}

module "iam" {
  source = "./modules/iam"
}