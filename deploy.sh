#!/bin/bash

# Set image name (change to your preferred name)
IMAGE_NAME="my-nextjs-app-npm"
IMAGE_TAG="latest"

# 1. Build Docker image
echo "Building Docker image..."
docker build -t ${IMAGE_NAME}:${IMAGE_TAG} .
if [ $? -ne 0 ]; then
    echo "Docker image build failed."
    exit 1
fi
echo "Docker image built successfully: ${IMAGE_NAME}:${IMAGE_TAG}"

# 2. Load image into MicroK8s (for MicroK8s to use local images)
echo "Loading image into MicroK8s..."
microk8s ctr image import ${IMAGE_NAME}:${IMAGE_TAG}
if [ $? -ne 0 ]; then
    echo "MicroK8s image import failed. The image might already exist or there's another issue."
    # You might want to add more robust error handling here
fi
echo "Image loaded into MicroK8s successfully."

# 3. Deploy Kubernetes YAML files
echo "Deploying Kubernetes YAML files..."
microk8s kubectl apply -f kubernetes/deployment.yaml
microk8s kubectl apply -f kubernetes/service.yaml

if [ $? -ne 0 ]; then
    echo "Kubernetes YAML deployment failed."
    exit 1
fi
echo "Kubernetes YAML deployed successfully."

echo "Deployment complete! Check the status with these commands:"
echo "microk8s kubectl get pods -l app=my-nextjs-app"
echo "microk8s kubectl get svc my-nextjs-service"