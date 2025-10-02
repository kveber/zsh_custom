# Docker

# Se o binário docker não existe, sai silenciosamente
if ! command -v docker &>/dev/null; then
  return
fi

# Só carrega se o daemon estiver ativo
if ! docker info &>/dev/null; then
  return
fi


alias d="docker"
alias dc="docker compose"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dstop="docker stop $(docker ps -q)"
