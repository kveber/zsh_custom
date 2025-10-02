# Python helpers
unalias python-init 2>/dev/null
python-init() {
  if [[ ! -d .venv ]]; then
    python -m venv .venv || return 1
  fi
  source .venv/bin/activate
  if [[ -f requirements.txt ]]; then
    pip install -r requirements.txt
  fi
}

alias pyinit='python-init'

# Cria e ativa venv com pyenv
py-venv() {
  if [ -z "$1" ]; then
    echo "Uso: py-venv <python_version>"
    return 1
  fi
  pyenv install -s "$1"
  pyenv virtualenv "$1" venv-"$1"
  pyenv activate venv-"$1"
}

# Checar qualidade
alias pycheck="flake8 . && black --check . && mypy ."

# Corrigir formatação
alias pyfix="black . && isort ."
