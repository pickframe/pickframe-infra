output "cluster_endpoint" {
  value = aws_eks_cluster.cluster.endpoint
}

output "cluster_ca_certificate" {
  value = base64decode(aws_eks_cluster.cluster.certificate_authority[0].data)
  depends_on = [ aws_eks_cluster.cluster ]
}

output "eks_sucurity_group_id" {
  value = aws_security_group.eks_sg.id
}