#!/bin/bash

echo "Next.js MicroK8s 배포 시작..."

# 기존 배포 정리
echo "기존 배포 정리 중..."
microk8s kubectl delete deployment nextjs-app --ignore-not-found=true
microk8s kubectl delete service nextjs-service --ignore-not-found=true

# 완전히 삭제될 때까지 대기
echo "리소스 정리 대기 중..."
sleep 10

# Docker 이미지 빌드
echo "Docker 이미지 빌드 중..."
docker build -t nextjs-app:latest .

# MicroK8s에 이미지 import (새로운 방법)
echo "MicroK8s에 이미지 가져오기..."
docker save nextjs-app:latest > nextjs-app.tar
microk8s ctr images import nextjs-app.tar
rm nextjs-app.tar

# 이미지 확인
echo "이미지 확인:"
microk8s ctr images ls | grep nextjs-app

# Kubernetes 리소스 배포
echo "Kubernetes 리소스 배포 중..."
microk8s kubectl apply -f nextjs-deployment.yaml
microk8s kubectl apply -f nextjs-service.yaml

# 배포 상태 확인 (타임아웃 설정)
echo "배포 상태 확인 중..."
microk8s kubectl rollout status deployment/nextjs-app --timeout=300s

# Pod 상태 확인
echo "Pod 상태:"
microk8s kubectl get pods -l app=nextjs-app

# 서비스 정보 출력
echo "서비스 정보:"
microk8s kubectl get services nextjs-service

echo "배포 완료!"
echo ""
echo "문제 해결 명령어:"
echo "Pod 로그 확인: microk8s kubectl logs -l app=nextjs-app"
echo "Pod 상세 정보: microk8s kubectl describe pods -l app=nextjs-app"
echo "이벤트 확인: microk8s kubectl get events --sort-by=.metadata.creationTimestamp"