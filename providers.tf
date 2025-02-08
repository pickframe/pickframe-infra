terraform {
  required_version = ">=0.13.1"
  required_providers {
    aws = ">=3.54.0"
    local = ">=2.1.0"
  }

  # NOTA: Necessário ter o bucket criado.
  backend "s3" {
    bucket = "pickframe-infra-bucket"
    key = "terraform.tfstate"
    region = "us-east-1"
  }
}

provider "aws" {
  region  = "us-east-1"
}

provider "kubernetes" {
  host                   = module.new-eks.cluster_endpoint
  cluster_ca_certificate = module.new-eks.cluster_ca_certificate
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    command     = "aws"
    args = ["eks", "get-token", "--cluster-name", "${var.prefix}-${var.cluster_name}"]
  }
}