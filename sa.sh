#!/bin/bash

# Define the namespace and service account name
NAMESPACE="default"  # Replace with your namespace
SERVICE_ACCOUNT="deployer"

# Find the secret of type "ServiceAccountToken" and name starting with "deployer-token"
SECRET_NAME=$(kubectl get secrets -n $NAMESPACE -o json | jq -r '.items[] | select(.type == "kubernetes.io/service-account-token" and .metadata.name | startswith("deployer-token")) | .metadata.name' | head -n 1)

if [ -z "$SECRET_NAME" ]; then
    echo "No matching secret found."
    exit 1
fi

echo "Found secret: $SECRET_NAME"

# Create a patch file to update the service account
PATCH_JSON=$(cat <<EOF
{
  "secrets": [
    {
      "name": "$SECRET_NAME"
    }
  ]
}
EOF
)

# Apply the patch to add the secret to the service account
kubectl patch serviceaccount $SERVICE_ACCOUNT -p "$PATCH_JSON" -n $NAMESPACE

echo "Assigned secret $SECRET_NAME to service account $SERVICE_ACCOUNT."
