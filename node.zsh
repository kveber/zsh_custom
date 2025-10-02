# @cat: node
# @desc: Atalhos para nvm e limpeza de projetos Node
# Node helpers
command -v nvm >/dev/null || return

# @desc: Trocar versão de Node com nvm
alias nvm-use="nvm use"
# @desc: Lista versões instaladas e disponíveis no nvm
alias nvm-ls="nvm ls"

# @desc: Limpar projeto Node (node_modules + lock + reinstall)
alias clean-node="rm -rf node_modules && rm -f package-lock.json yarn.lock && yarn install"
