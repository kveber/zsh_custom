#!/usr/bin/env bash
set -euo pipefail

ZSHRC_FILE="${HOME}/.zshrc"
CUSTOM_DIR="${HOME}/.zsh_custom"

mkdir -p "${CUSTOM_DIR}"

# Ensure ~/.zshrc exists
if [[ ! -f "${ZSHRC_FILE}" ]]; then
  touch "${ZSHRC_FILE}"
fi

# Create a backup once per run if not already created in the last minute
if [[ ! -f "${ZSHRC_FILE}.bak" ]] || [[ $(($(date +%s) - $(stat -f %m "${ZSHRC_FILE}.bak" 2>/dev/null || echo 0))) -gt 60 ]]; then
  cp "${ZSHRC_FILE}" "${ZSHRC_FILE}.bak"
fi

BEGIN_MARK="# BEGIN ZSH_CUSTOM"
END_MARK="# END ZSH_CUSTOM"
BLOCK_CONTENT=$'\n# BEGIN ZSH_CUSTOM\n# Importa funções personalizadas de ~/.zsh_custom\nfor f in ~/.zsh_custom/*.zsh(.N); do\n  source "$f"\ndone\n# END ZSH_CUSTOM\n'

ACTION="install"
if [[ "${1-}" == "--uninstall" ]]; then
  ACTION="uninstall"
fi

if [[ "$ACTION" == "uninstall" ]]; then
  if grep -Fq "$BEGIN_MARK" "${ZSHRC_FILE}"; then
    # Remove block between markers
    awk -v b="$BEGIN_MARK" -v e="$END_MARK" '
      BEGIN {skip=0}
      index($0,b){skip=1; next}
      index($0,e){skip=0; next}
      skip==0 {print}
    ' "${ZSHRC_FILE}" > "${ZSHRC_FILE}.tmp" && mv "${ZSHRC_FILE}.tmp" "${ZSHRC_FILE}"
    echo "Bloco ZSH_CUSTOM removido de ${ZSHRC_FILE}."
  else
    echo "Nenhum bloco ZSH_CUSTOM encontrado em ${ZSHRC_FILE}."
  fi
else
  if grep -Fq "$BEGIN_MARK" "${ZSHRC_FILE}"; then
    echo "Bloco ZSH_CUSTOM já existe em ${ZSHRC_FILE}."
  else
    # Add a newline if file does not end with one
    if [[ -s "${ZSHRC_FILE}" ]] && [[ -n "$(tail -c1 "${ZSHRC_FILE}" || true)" ]]; then
      echo >> "${ZSHRC_FILE}"
    fi
    printf "%s" "${BLOCK_CONTENT}" >> "${ZSHRC_FILE}"
    echo "Bloco ZSH_CUSTOM adicionado ao ${ZSHRC_FILE}."
  fi
fi

# Reload ~/.zshrc after changes
if [[ -n "${ZSH_VERSION-}" ]]; then
  # Running under zsh: safe to source directly
  source "${ZSHRC_FILE}"
  echo "${ZSHRC_FILE} foi recarregado."
else
  # Not running under zsh: use zsh to load it to avoid errors (e.g., fpath)
  if command -v zsh >/dev/null 2>&1; then
    zsh -ic "source '${ZSHRC_FILE}'" >/dev/null 2>&1 || true
    echo "${ZSHRC_FILE} foi recarregado via zsh. Para aplicar neste shell, execute: source ~/.zshrc"
  else
    echo "zsh não encontrado. Para aplicar neste shell, execute: source ~/.zshrc"
  fi
fi


