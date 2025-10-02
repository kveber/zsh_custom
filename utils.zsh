# @cat: utils
# @desc: Utilitários gerais (ex.: gerenciamento de portas)
# Atalhos rápidos de dev

## Docker/Kubernetes aliases moved to dedicated files (docker.zsh, k8s.zsh)

# Python (migrado para python.zsh)

# ---------------------------------------------------
# @desc: Gerencia portas (listar, identificar e liberar)
# PORTS: ver e liberar portas
# ---------------------------------------------------

ports() {
  # Cores
  RED="\033[0;31m"
  GREEN="\033[0;32m"
  YELLOW="\033[1;33m"
  CYAN="\033[0;36m"
  BOLD="\033[1m"
  RESET="\033[0m"

  case "$1" in
    ""|--help|-h)
      echo -e "${BOLD}Uso:${RESET} ports <comando> [argumentos]"
      echo ""
      echo -e "${BOLD}Comandos:${RESET}"
      echo -e "  ${CYAN}list${RESET}              Lista todas as portas em uso"
      echo -e "  ${CYAN}who <porta>${RESET}       Mostra qual processo está usando a porta"
      echo -e "  ${CYAN}free <porta>${RESET}      Mata o processo que está usando a porta"
      echo -e "  ${CYAN}--help, -h${RESET}        Mostra esta ajuda"
      echo ""
      echo -e "${BOLD}Exemplos:${RESET}"
      echo "  ports list"
      echo "  ports who 3000"
      echo "  ports free 3000"
      return 0
      ;;

    list)
      echo -e "${BOLD}🔎 Portas em uso:${RESET}"
      lsof -i -P -n | grep LISTEN | awk -v c="$CYAN" -v r="$RESET" -v y="$YELLOW" '
        NR==1 {next}
        {printf "%s%-8s%s PID:%s%-6s%s PORT:%s%s%s\n", c,$1,r,y,$2,r,y,$9,r}
      '
      ;;

    who)
      if [ -z "$2" ]; then
        echo -e "${YELLOW}Uso:${RESET} ports who <porta>"
        return 1
      fi
      echo -e "🔎 ${BOLD}Processos na porta${RESET} ${CYAN}$2${RESET}:"
      lsof -i :$2 -n -P | awk -v c="$CYAN" -v y="$YELLOW" -v r="$RESET" '
        NR==1 {print; next}
        {printf "%s%-8s%s PID:%s%-6s%s %s\n", c,$1,r,y,$2,r,$9}
      '
      ;;

    free)
      if [ -z "$2" ]; then
        echo -e "${YELLOW}Uso:${RESET} ports free <porta>"
        return 1
      fi
      pid=$(lsof -t -i :$2)
      if [ -z "$pid" ]; then
        echo -e "✅ ${GREEN}Nenhum processo encontrado na porta${RESET} ${CYAN}$2${RESET}"
      else
        echo -e "🛑 ${RED}Processo(s)${RESET} na porta ${CYAN}$2${RESET}: ${YELLOW}$pid${RESET}"
        read "?Deseja encerrar esses processos? [y/N] " ans
        [[ "$ans" == [yY]* ]] || { echo "Cancelado."; return 1; }
        kill $pid 2>/dev/null || true
        sleep 1
        kill -9 $pid 2>/dev/null || true
        echo -e "✅ ${GREEN}Porta${RESET} ${CYAN}$2${RESET} ${GREEN}liberada.${RESET}"
      fi
      ;;

    *)
      echo -e "${RED}Comando inválido:${RESET} $1"
      echo "Use 'ports --help' para ver as opções."
      return 1
      ;;
  esac
}
