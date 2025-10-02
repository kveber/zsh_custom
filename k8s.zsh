# @cat: kubernetes
# @desc: Atalhos e funções para trabalhar com kubectl
# Kubernetes helpers
command -v kubectl >/dev/null || return

# @desc: Alias curto para kubectl
alias k="kubectl"
# @desc: Lista pods
alias kgp="kubectl get pods"
# @desc: Lista services
alias kgs="kubectl get svc"
# @desc: Lista nodes
alias kgn="kubectl get nodes"


# @desc: Troca o namespace atual do contexto
# Trocar namespace
kns() {
  if [ -z "$1" ]; then
    echo "Uso: kns <namespace>"
    return 1
  fi
  kubectl config set-context --current --namespace="$1"
}

# @desc: Troca o contexto/cluster atual
# Trocar cluster
kctx() {
  if [ -z "$1" ]; then
    echo "Clusters disponíveis:"
    kubectl config get-contexts -o name
    return 1
  fi
  kubectl config use-context "$1"
}

# @desc: Top pods em todos os namespaces
alias ktop="kubectl top pods --all-namespaces"

# @desc: Segue logs de um pod (opcional: container)
# Logs de um pod
klogs() {
  if [ -z "$1" ]; then
    echo "Uso: klogs <pod-name> [container]"
    return 1
  fi
  kubectl logs -f "$@"
}
