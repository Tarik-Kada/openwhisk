#!/bin/bash

# Start KinD cluster using the script from openwhisk-deploy-kube
bash "./openwhisk-deploy-kube/deploy/kind/start-kind.sh"

# Assigne invoker role to a worker node
kubectl label node --all openwhisk-role=invoker

# # Build OpenWhisk components
# cd openwhisk
# sudo ./gradlew distDocker
# cd ..

# components=("controller" "invoker" "scheduler" "user-events" "scala")

# for component in "${components[@]}"; do
#   # Load the image into your KinD cluster
#   docker tag "whisk/$component" "whisk/$component:latest"

#   kind load docker-image whisk/$component
# done
# echo "Images loaded successfully."

# Add OpenWhisk Helm repo and update
helm repo add openwhisk https://openwhisk.apache.org/charts
helm repo update

# Install OpenWhisk using Helm
helm install owdev openwhisk/openwhisk -n openwhisk --create-namespace
# helm install owdev openwhisk/openwhisk -n openwhisk --create-namespace -f ./openwhisk-deploy-kube/deploy/kind/mycluster.yaml

echo "Waiting for OpenWhisk to be ready..."
sleep 30

# Configure wsk CLI properties. Assumes NodePort and default system auth key setup.
WSK_PORT=$(kubectl get svc -n openwhisk owdev-nginx -o=jsonpath='{.spec.ports[?(@.port==443)].nodePort}')
WSK_HOST=$(kubectl get node -o wide | awk 'NR==2{print $6}')
WSK_AUTH=$(kubectl get secret owdev-whisk.auth -n openwhisk -o=jsonpath='{.data.system}' | base64 --decode)

wsk property set --apihost localhost:31001
wsk property set --auth $WSK_AUTH