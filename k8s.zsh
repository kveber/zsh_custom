# Kubernetes helpers

alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get svc"
alias kgn="kubectl get nodes"


# Trocar namespace
kns() {
  if [ -z "$1" ]; then
    echo "Uso: kns <namespace>"
    return 1
  fi
  kubectl config set-context --current --namespace="$1"
}

# Trocar cluster
kctx() {
  if [ -z "$1" ]; then
    echo "Clusters disponíveis:"
    kubectl config get-contexts -o name
    return 1
  fi
  kubectl config use-context "$1"
}

# Top pods
alias ktop="kubectl top pods --all-namespaces"

# Logs de um pod
klogs() {
  if [ -z "$1" ]; then
    echo "Uso: klogs <pod-name> [container]"
    return 1
  fi
  kubectl logs -f "$@"
}
