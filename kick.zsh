# Função: kick
# Desconecta usuários do macOS via launchctl
# Suporta: --help, --list, --all, --dry-run, username ou UID

kick() {
  # Cores
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[1;33m"
  CYAN="\033[0;36m"
  BOLD="\033[1m"
  RESET="\033[0m"

  case "$1" in
    ""|--help|-h)
      echo -e "${BOLD}Uso:${RESET} kick <username|uid|opções>"
      echo ""
      echo -e "${BOLD}Opções:${RESET}"
      echo -e "  ${CYAN}<username>${RESET}       Desconecta o usuário pelo nome"
      echo -e "  ${CYAN}<uid>${RESET}            Desconecta o usuário pelo UID"
      echo -e "  ${CYAN}--all${RESET}            Desconecta todos os usuários logados exceto o atual"
      echo -e "  ${CYAN}--list${RESET}           Lista apenas os usuários ativos no momento"
      echo -e "  ${CYAN}--dry-run${RESET}        Simula a ação (usar antes de <username>, <uid> ou --all)"
      echo -e "  ${CYAN}--help, -h${RESET}       Mostra esta ajuda"
      echo ""
      echo -e "${BOLD}Exemplos:${RESET}"
      echo "  kick klaus"
      echo "  kick 501"
      echo "  kick --all"
      echo "  kick --dry-run klaus"
      echo "  kick --dry-run --all"
      echo "  kick --list"
      return 0
      ;;
    --list)
      echo -e "${BOLD}Usuários ativos no momento:${RESET}"
      who | awk '{print $1}' | sort -u | while read user; do
        uid=$(id -u "$user" 2>/dev/null)
        realname=$(dscl . -read /Users/"$user" RealName 2>/dev/null | tail -1)
        printf "  ${CYAN}%-15s${RESET} UID: ${YELLOW}%-5s${RESET} Nome: %s\n" "$user" "$uid" "$realname"
      done
      return 0
      ;;
  esac

  dry_run=0
  if [ "$1" = "--dry-run" ]; then
    dry_run=1
    shift
    [ -z "$1" ] && echo -e "${YELLOW}→ Modo simulação: especifique <username|uid|--all>${RESET}" && return 1
  fi

  if [ "$1" = "--all" ]; then
    current_uid=$(id -u)
    echo -e "${BOLD}Desconectando todos os usuários, exceto o atual (UID $current_uid)...${RESET}"
    users=$(who | awk '{print $1}' | sort -u)
    count=0

    for user in $users; do
      uid=$(id -u "$user" 2>/dev/null)
      if [ "$uid" != "$current_uid" ] && [ -n "$uid" ]; then
        if [ $dry_run -eq 1 ]; then
          echo -e " → ${YELLOW}(SIMULAÇÃO)${RESET} Desconectaria ${CYAN}$user${RESET} (UID ${YELLOW}$uid${RESET})"
        else
          echo -e " → ${RED}Desconectando${RESET} ${CYAN}$user${RESET} (UID ${YELLOW}$uid${RESET})"
          sudo launchctl bootout "user/$uid"
        fi
        count=$((count+1))
      fi
    done

    echo ""
    if [ $dry_run -eq 1 ]; then
      echo -e "${YELLOW}Resumo:${RESET} $count usuário(s) ${YELLOW}seriam${RESET} desconectado(s)."
    else
      echo -e "${GREEN}Resumo:${RESET} $count usuário(s) desconectado(s)."
    fi
    return 0
  fi

  local arg="$1"
  local uid=""

  if [[ "$arg" =~ ^[0-9]+$ ]]; then
    uid="$arg"
  else
    uid=$(id -u "$arg" 2>/dev/null)
  fi

  if [ -z "$uid" ]; then
    echo -e "${RED}Usuário ou UID inválido:${RESET} $arg"
    return 1
  fi

  if [ $dry_run -eq 1 ]; then
    echo -e " → ${YELLOW}(SIMULAÇÃO)${RESET} Desconectaria usuário ${CYAN}$arg${RESET} (UID ${YELLOW}$uid${RESET})"
  else
    echo -e "${RED}Desconectando${RESET} usuário ${CYAN}$arg${RESET} (UID ${YELLOW}$uid${RESET})..."
    sudo launchctl bootout "user/$uid"
  fi
}
