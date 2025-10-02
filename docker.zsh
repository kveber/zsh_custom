# @cat: docker
# @desc: Atalhos para Docker e docker compose
# Docker

# Se o binário docker não existe, sai silenciosamente
if ! command -v docker &>/dev/null; then
  return
fi

# Só carrega se o daemon estiver ativo
if ! docker info &>/dev/null; then
  return
fi


# @desc: Alias curto para docker
alias d="docker"
# @desc: Alias curto para docker compose
alias dc="docker compose"
# @desc: Lista containers com nome, status e portas
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"

# @desc: Para todos os containers em execução
unalias dstop 2>/dev/null
dstop() {
  local ids
  ids=(${(f)$(docker ps -q)})
  if (( ${#ids} == 0 )); then
    echo "Nada para parar."
    return 0
  fi
  docker stop ${ids[@]}
}
