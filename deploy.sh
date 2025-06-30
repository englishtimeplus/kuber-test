#!/bin/bash

# Configuration
APP_NAME="nextjs-app"
IMAGE_NAME="nextjs-app"
TAG="latest"
REGISTRY="localhost:32000" # MicroK8s default registry port
NAMESPACE="default"

# Build Docker image
echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${TAG} .

# Push to MicroK8s registry
echo "Pushing to MicroK8s registry..."
docker tag ${IMAGE_NAME}:${TAG} ${REGISTRY}/${IMAGE_NAME}:${TAG}
docker push ${REGISTRY}/${IMAGE_NAME}:${TAG}

# Enable required MicroK8s addons
echo "Enabling MicroK8s addons..."
microk8s enable dns
microk8s enable registry
microk8s enable ingress

# Apply Kubernetes manifests
echo "Applying Kubernetes manifests..."
microk8s kubectl apply -f deploy-nextjs.yaml

# Wait for deployment to be ready
echo "Waiting for deployment to be ready..."
microk8s kubectl wait --for=condition=available --timeout=300s deployment/${APP_NAME} -n ${NAMESPACE}

# Get service information
echo "Deployment complete! Service information:"
microk8s kubectl get svc ${APP_NAME}-service -n ${NAMESPACE}
echo "Ingress information:"
microk8s kubectl get ingress ${APP_NAME}-ingress -n ${NAMESPACE}