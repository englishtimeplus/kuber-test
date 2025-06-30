#!/bin/bash

echo "Next.js MicroK8s 배포 시작..."

# Docker 이미지 빌드
echo "Docker 이미지 빌드 중..."
docker build -t nextjs-app:latest .

# MicroK8s에 이미지 import
echo "MicroK8s에 이미지 가져오기..."
docker save nextjs-app:latest | microk8s ctr image import -

# Kubernetes 리소스 배포
echo "Kubernetes 리소스 배포 중..."
microk8s kubectl apply -f nextjs-deployment.yaml
microk8s kubectl apply -f nextjs-service.yaml

# 배포 상태 확인
echo "배포 상태 확인 중..."
microk8s kubectl rollout status deployment/nextjs-app

# 서비스 정보 출력
echo "서비스 정보:"
microk8s kubectl get services nextjs-service

echo "배포 완료!"
echo "애플리케이션 상태 확인: microk8s kubectl get pods"
echo "로그 확인: microk8s kubectl logs -l app=nextjs-app"