output "eks-node-group-role" {
  value = aws_iam_role.eks-node-role.arn
}

output "vpc-cni-role" {
  value = aws_iam_role.vpc-cni-pod-identity-role.arn
}

output "eks-cluster-role" {
  value = aws_iam_role.eks-cluster-role.arn
}

output "eks-role-attachment" {
  value = aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy
}

output "node-group-ec2-attachment" {
  value = aws_iam_role_policy_attachment.node-policy-ec2
}

output "node-group-ecr-attachment" {
  value = aws_iam_role_policy_attachment.node-policy-ec2_registry
}

output "ebs_csi_driver_role_arn" {
  value = aws_iam_role.ebs_csi_driver.arn
}