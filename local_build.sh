#!/bin/bash

# Define variables
OPENWHISK_DIR="openwhisk"  # Adjust if your directory has a different name
DOCKER_REGISTRY="tarikkada"  # Change this to your Docker Hub username or private registry URL
NAMESPACE="openwhisk"
HELM_RELEASE="owdev"

# Navigate to OpenWhisk directory
cd "$OPENWHISK_DIR"

# List of OpenWhisk components to build and deploy
# Add or remove components as necessary based on your changes
# components=("controller" "invoker" "scheduler" "user-events" "scala")
# components=("controller")

# Build Docker images
sudo ./gradlew distDocker

images=("controller" "invoker" "scheduler" "user-events" "scala")
for image in "${images[@]}"; do
  docker tag "whisk/$image:latest" "$DOCKER_REGISTRY/$image:latest"
  docker push "$DOCKER_REGISTRY/$image:latest"
done

echo "Images built and pushed successfully."
