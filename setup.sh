#!/bin/bash

# Defina a região
REGION="us-east-1"

# Defina os nomes dos buckets (devem ser únicos globalmente)
BUCKET_NAME_1="pickframe-infra-bucket"
BUCKET_NAME_1="pickframe-infradata-bucket"

# Defina o nome do repositório ECR
ECR_REPOSITORY_NAME="picframe-image"

# Função para criar um bucket S3
create_bucket() {
    BUCKET_NAME=$1
    echo "Criando bucket: $BUCKET_NAME na região $REGION..."
    
    # Comando AWS CLI para criar o bucket
    aws s3api create-bucket --bucket "$BUCKET_NAME" --region "$REGION" --no-cli-pager
    
    if [ $? -eq 0 ]; then
        echo "Bucket $BUCKET_NAME criado com sucesso!"
    else
        echo "Falha ao criar o bucket $BUCKET_NAME."
    fi
}

# Função para criar um repositório ECR
create_ecr_repository() {
    echo "Criando repositório ECR: $ECR_REPOSITORY_NAME na região $REGION..."
    
    # Comando AWS CLI para criar o repositório ECR
    aws ecr create-repository --repository-name "$ECR_REPOSITORY_NAME" --region "$REGION" --no-cli-pager
    
    if [ $? -eq 0 ]; then
        echo "Repositório ECR $ECR_REPOSITORY_NAME criado com sucesso!"
    else
        echo "Falha ao criar o repositório ECR $ECR_REPOSITORY_NAME."
    fi
}

# Criar os 3 buckets
create_bucket "$BUCKET_NAME_1"
create_bucket "$BUCKET_NAME_2"

# Criar o repositório ECR
create_ecr_repository

echo "Script finalizado."