# Docker
alias d="docker"
alias dc="docker compose"
alias dps="docker ps --format 'table {{.Names}}\t{{.Status}}\t{{.Ports}}'"
alias dstop="docker stop $(docker ps -q)"
