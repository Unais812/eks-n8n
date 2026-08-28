output "eks-node-group-role" {
  value = aws_iam_role.eks-node-role.arn
}

output "vpc-cni-role" {
  value = aws_iam_role.vpc-cni-pod-identity-role.arn
}