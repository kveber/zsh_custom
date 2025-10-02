# AWS / GCP helpers

command -v aws >/dev/null || echo "Aviso: aws não encontrado" >/dev/null
command -v gcloud >/dev/null || echo "Aviso: gcloud não encontrado" >/dev/null

# Trocar perfil AWS
aws-profile() {
  if [ -z "$1" ]; then
    echo "Perfis disponíveis:"
    grep "^\[" ~/.aws/credentials
    return 1
  fi
  export AWS_PROFILE="$1"
  echo "AWS_PROFILE setado para $AWS_PROFILE"
}

# Listar clusters
alias eks-clusters="aws eks list-clusters --output table"
alias gke-clusters="gcloud container clusters list"

# Usar cluster EKS
eks-use() {
  if [ -z "$1" ]; then
    echo "Uso: eks-use <cluster-name> <region>"
    return 1
  fi
  aws eks update-kubeconfig --name "$1" --region "${2:-us-east-1}"
}

# Usar cluster GKE
gke-use() {
  if [ $# -lt 2 ]; then
    echo "Uso: gke-use <cluster-name> <zone>"
    return 1
  fi
  gcloud container clusters get-credentials "$1" --zone "$2"
}
