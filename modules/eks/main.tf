resource "aws_security_group" "eks_sg" {
  vpc_id = var.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.prefix}-sg"
  }
}

resource "aws_eks_cluster" "cluster" {
  name = "${var.prefix}-${var.cluster_name}"
  #role_arn = aws_iam_role.cluster.arn
  role_arn = var.lab-role-arn
  enabled_cluster_log_types = ["api","audit"]
  vpc_config {
    subnet_ids = var.subnet_ids
    security_group_ids = [aws_security_group.eks_sg.id]
  }
}

resource "aws_eks_node_group" "node-1" {
  cluster_name = aws_eks_cluster.cluster.name
  node_group_name = "node-1"
  node_role_arn = var.lab-role-arn
  subnet_ids = var.subnet_ids
  instance_types = ["t2.micro"]
  
  scaling_config {
    desired_size = var.desired_size
    max_size = var.max_size
    min_size = var.min_size
  }
}