#!/bin/bash

# Docker management script for kuber-test

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [COMMAND]"
    echo ""
    echo "Commands:"
    echo "  build       Build production Docker image"
    echo "  build-dev   Build development Docker image"
    echo "  run         Run production container"
    echo "  run-dev     Run development container"
    echo "  stop        Stop all containers"
    echo "  clean       Remove all containers and images"
    echo "  logs        Show container logs"
    echo "  shell       Open shell in running container"
    echo "  help        Show this help message"
}

# Function to build production image
build_production() {
    print_status "Building production Docker image..."
    docker build -t kuber-test:latest .
    print_status "Production image built successfully!"
}

# Function to build development image
build_development() {
    print_status "Building development Docker image..."
    docker build -f Dockerfile.dev -t kuber-test:dev .
    print_status "Development image built successfully!"
}

# Function to run production container
run_production() {
    print_status "Starting production container..."
    docker run -d --name kuber-test-prod -p 3000:3000 kuber-test:latest
    print_status "Production container started on http://localhost:3000"
}

# Function to run development container
run_development() {
    print_status "Starting development container..."
    docker run -d --name kuber-test-dev -p 3001:3000 -v $(pwd):/app -v /app/node_modules kuber-test:dev
    print_status "Development container started on http://localhost:3001"
}

# Function to stop containers
stop_containers() {
    print_status "Stopping containers..."
    docker stop kuber-test-prod kuber-test-dev 2>/dev/null || true
    docker rm kuber-test-prod kuber-test-dev 2>/dev/null || true
    print_status "Containers stopped and removed!"
}

# Function to clean everything
clean_all() {
    print_warning "This will remove all containers and images. Are you sure? (y/N)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
        print_status "Cleaning up..."
        docker stop $(docker ps -aq) 2>/dev/null || true
        docker rm $(docker ps -aq) 2>/dev/null || true
        docker rmi kuber-test:latest kuber-test:dev 2>/dev/null || true
        print_status "Cleanup completed!"
    else
        print_status "Cleanup cancelled."
    fi
}

# Function to show logs
show_logs() {
    if docker ps | grep -q kuber-test-prod; then
        print_status "Showing production container logs..."
        docker logs -f kuber-test-prod
    elif docker ps | grep -q kuber-test-dev; then
        print_status "Showing development container logs..."
        docker logs -f kuber-test-dev
    else
        print_error "No running containers found!"
    fi
}

# Function to open shell
open_shell() {
    if docker ps | grep -q kuber-test-prod; then
        print_status "Opening shell in production container..."
        docker exec -it kuber-test-prod /bin/sh
    elif docker ps | grep -q kuber-test-dev; then
        print_status "Opening shell in development container..."
        docker exec -it kuber-test-dev /bin/sh
    else
        print_error "No running containers found!"
    fi
}

# Main script logic
case "${1:-help}" in
    build)
        build_production
        ;;
    build-dev)
        build_development
        ;;
    run)
        stop_containers
        run_production
        ;;
    run-dev)
        stop_containers
        run_development
        ;;
    stop)
        stop_containers
        ;;
    clean)
        clean_all
        ;;
    logs)
        show_logs
        ;;
    shell)
        open_shell
        ;;
    help|*)
        show_usage
        ;;
esac 