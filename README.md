kubectl get secrets --namespace=<NAMESPACE> -o json | jq -r '.items[] | select(.type=="kubernetes.io/service-account-token") | .metadata.name'

kubectl get secrets --namespace=<NAMESPACE> -o json | jq -r '.items[] | select(.metadata.name | startswith("deployer-token")) | select(.type=="kubernetes.io/service-account-token") | .metadata.name'

kubectl patch serviceaccount deployer -p '{"secrets": [{"name": "deployer-token-xyz"}]}' --namespace=<NAMESPACE>
