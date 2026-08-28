resource "aws_eks_cluster" "eks-cluster" {
  name = "eks-cluster"


  access_config {
    authentication_mode                         = "API_AND_CONFIG_MAP"
    bootstrap_cluster_creator_admin_permissions = true
  }

  role_arn = aws_iam_role.eks-cluster-role.arn
  version  = var.version-k8s

  vpc_config {
    subnet_ids = [var.private-subnets]
  }

  # Ensure that IAM Role permissions are created before and deleted
  # after EKS Cluster handling. Otherwise, EKS will not be able to
  # properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
  ]
}

resource "aws_eks_addon" "vpc-cni" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "vpc-cni"
  resolve_conflicts_on_update = "OVERWRITE" # Ensures AWS is source of truth and ignores manual changes
}

resource "aws_eks_addon" "coredns" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "coredns"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_addon" "kube-proxy" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "kube-proxy"
  resolve_conflicts_on_update = "OVERWRITE"
}
resource "aws_eks_addon" "eks-pod-identity-agent" {
  cluster_name                = aws_eks_cluster.eks-cluster.name
  addon_name                  = "eks-pod-identity-agent"
  resolve_conflicts_on_update = "OVERWRITE"
}

resource "aws_eks_node_group" "eks-node-group" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "eks-node-group"
  node_role_arn   = var.eks-node-group-role
  subnet_ids      = [var.private-subnets]
  ami_type        = var.ami
  instance_types  = [var.instance-type]

  scaling_config {
    desired_size = var.desired-size
    max_size     = var.max-size
    min_size     = var.min-size
  }

  update_config {
    max_unavailable = 1
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.node-policy-ec2,
    aws_iam_role_policy_attachment.node-policy-ec2_registry,
  ]
}

resource "aws_eks_pod_identity_association" "vpc-cni" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  namespace       = "kube-system"
  service_account = "aws-node"
  role_arn        = var.vpc-cni-role

  depends_on = [
    aws_eks_addon.eks-pod-identity-agent,
    aws_eks_addon.vpc-cni
  ]
}