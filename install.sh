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

BLOCK_START="# Importa funções personalizadas de ~/.zsh_custom"
BLOCK_CONTENT=$'\n# Importa funções personalizadas de ~/.zsh_custom\nfor f in ~/.zsh_custom/*.zsh; do\n  source "$f"\ndone\n'

# If similar block already exists (by loop line), skip appending
if grep -Fq "for f in ~/.zsh_custom/*.zsh; do" "${ZSHRC_FILE}"; then
  echo "Bloco de ~/.zsh_custom já existe em ${ZSHRC_FILE}."
else
  # Add a newline if file does not end with one
  if [[ -s "${ZSHRC_FILE}" ]] && [[ -n "$(tail -c1 "${ZSHRC_FILE}" || true)" ]]; then
    echo >> "${ZSHRC_FILE}"
  fi
  printf "%s" "${BLOCK_CONTENT}" >> "${ZSHRC_FILE}"
  echo "Bloco adicionado ao ${ZSHRC_FILE}."
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


