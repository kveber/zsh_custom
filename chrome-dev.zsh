# Script: chrome-dev
# Abre o Google Chrome em modo desenvolvedor sem restrições de segurança
# ⚠️ Use apenas para testes de desenvolvimento!

chrome-dev() {
  CHROME_PATH="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome"
  PROFILE_DIR="$HOME/.chrome-dev-profile"

  # Cores
  CYAN="\033[0;36m"
  YELLOW="\033[1;33m"
  GREEN="\033[0;32m"
  RED="\033[0;31m"
  BOLD="\033[1m"
  RESET="\033[0m"

  case "$1" in
    --help|-h)
      echo -e "${BOLD}Uso:${RESET} chrome-dev [URL|--reset|--incognito|--help]"
      echo ""
      echo -e "${BOLD}Opções:${RESET}"
      echo -e "  ${CYAN}[URL]${RESET}           Abre o Chrome em modo dev no endereço informado"
      echo -e "  ${CYAN}(sem argumento)${RESET} Abre em branco (about:blank)"
      echo -e "  ${CYAN}--incognito${RESET}     Abre em modo desenvolvedor + aba anônima"
      echo -e "  ${CYAN}--reset${RESET}         Apaga o perfil temporário usado pelo modo dev"
      echo -e "  ${CYAN}--help, -h${RESET}      Mostra esta ajuda"
      echo ""
      echo -e "${BOLD}Exemplos:${RESET}"
      echo "  chrome-dev"
      echo "  chrome-dev http://localhost:3000"
      echo "  chrome-dev --incognito https://meusite.dev"
      echo "  chrome-dev --reset"
      return 0
      ;;
    --reset)
      echo "Removendo perfil temporário em: $PROFILE_DIR"
      rm -rf "$PROFILE_DIR"
      echo -e "✅ ${GREEN}Perfil resetado com sucesso.${RESET}"
      return 0
      ;;
  esac

  if [ ! -x "$CHROME_PATH" ]; then
    echo -e "${RED}Google Chrome não encontrado em $CHROME_PATH${RESET}"
    return 1
  fi

  # Detecta se é incognito
  incognito=0
  if [ "$1" = "--incognito" ]; then
    incognito=1
    shift
  fi

  # Se não passar parâmetro, abre em branco
  local url="$1"
  if [ -z "$url" ]; then
    url="about:blank"
  fi

  if [ $incognito -eq 1 ]; then
    "$CHROME_PATH" \
      --disable-web-security \
      --disable-gpu \
      --disable-site-isolation-trials \
      --ignore-certificate-errors \
      --no-sandbox \
      --incognito \
      --new-window "$url"
  else
    "$CHROME_PATH" \
      --disable-web-security \
      --disable-gpu \
      --user-data-dir="$PROFILE_DIR" \
      --disable-site-isolation-trials \
      --ignore-certificate-errors \
      --no-sandbox \
      --new-window "$url"
  fi
}
