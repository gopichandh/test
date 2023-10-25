#!/bin/bash

# Get a list of all namespaces
NAMESPACES=$(kubectl get ns -o custom-columns=":metadata.name" --no-headers)

# Loop through each namespace and invoke assign_secret_to_sa.sh
for NAMESPACE in $NAMESPACES; do
    echo "Processing namespace: $NAMESPACE"
    ./assign_secret_to_sa.sh $NAMESPACE
done

echo "Finished processing all namespaces."
