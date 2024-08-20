#!/bin/bash

# 새 이미지 태그 (예: GitHub commit SHA)
NEW_TAG=${GITHUB_SHA}

# ECR 리포지토리 URL
ECR_REPO="213899591783.dkr.ecr.ap-northeast-3.amazonaws.com/gitops-repo"

# 새 이미지 빌드 및 푸시
docker build -t ${ECR_REPO}:${NEW_TAG} .
docker push ${ECR_REPO}:${NEW_TAG}

# Deployment YAML 파일 업데이트
sed -i "s|image: ${ECR_REPO}.*|image: ${ECR_REPO}:${NEW_TAG}|" k8s/deployment.yaml

# Git에 변경사항 커밋 및 푸시
git config --global user.name 'GitHub Actions'
git config --global user.email 'github-actions@github.com'
git add k8s/deployment.yaml
git commit -m "Update image tag to ${NEW_TAG}"
git push
