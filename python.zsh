# Python helpers
alias python-init="python -m venv .venv && source .venv/bin/activate && pip install -r requirements.txt"

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
