#!/bin/bash
# Docker deployment script with versioning (Shell script for macOS/Linux)
# Supports dev (1.x.x) and prod (2.x.x) versions

# Configuration - Update these as needed
DOCKER_HUB_USERNAME="sushilk676"
IMAGE_NAME="elio-backend"

echo "=========================================="
echo "Docker Image Deployment Script"
echo "=========================================="
echo ""

# Prompt for environment (dev or prod)
echo "Select environment:"
echo "1. Dev (versions start with 1.0.0)"
echo "2. Prod (versions start with 2.0.0)"
read -p "Enter choice (1 or 2): " env_choice

if [ "$env_choice" = "1" ]; then
    ENV="dev"
    VERSION_PREFIX="1"
elif [ "$env_choice" = "2" ]; then
    ENV="prod"
    VERSION_PREFIX="2"
else
    echo "Invalid choice. Exiting."
    exit 1
fi

echo ""
echo "Environment: $ENV"
echo "Version prefix: ${VERSION_PREFIX}.x.x"
echo ""

# Prompt for version number
read -p "Enter version (e.g., 0.0 for ${VERSION_PREFIX}.0.0 or 1.2 for ${VERSION_PREFIX}.1.2): " version_suffix

# Validate version format (should be numbers with dots)
if ! [[ "$version_suffix" =~ ^[0-9]+(\.[0-9]+)*$ ]]; then
    echo "Invalid version format. Please use format like: 0.0 or 1.2 or 1.2.3"
    exit 1
fi

# Construct full version
FULL_VERSION="${VERSION_PREFIX}.${version_suffix}"
IMAGE_TAG="${DOCKER_HUB_USERNAME}/${IMAGE_NAME}:${FULL_VERSION}"

echo ""
echo "=========================================="
echo "Building Docker image..."
echo "Image: $IMAGE_TAG"
echo "Environment: $ENV"
echo "=========================================="
echo ""

# Build Docker image
docker build --tag "$IMAGE_TAG" .

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Docker build failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "Pushing Docker image to Docker Hub..."
echo "Image: $IMAGE_TAG"
echo "=========================================="
echo ""

# Push Docker image to Docker Hub
docker push "$IMAGE_TAG"

if [ $? -ne 0 ]; then
    echo ""
    echo "❌ Docker push failed!"
    exit 1
fi

echo ""
echo "=========================================="
echo "✅ Success!"
echo "=========================================="
echo "Image successfully built and pushed:"
echo "  $IMAGE_TAG"
echo ""
echo "You can pull it using:"
echo "  docker pull $IMAGE_TAG"
echo ""
