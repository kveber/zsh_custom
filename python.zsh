# @cat: python
# @desc: Utilitários para ambientes virtuais e qualidade de código
# Python helpers
unalias python-init 2>/dev/null
# @desc: Cria/ativa .venv e instala requirements.txt
python-init() {
  if [[ ! -d .venv ]]; then
    python -m venv .venv || return 1
  fi
  source .venv/bin/activate
  if [[ -f requirements.txt ]]; then
    pip install -r requirements.txt
  fi
}

# @desc: Alias para python-init
alias pyinit='python-init'

# @desc: Cria e ativa venv com pyenv
py-venv() {
  if [ -z "$1" ]; then
    echo "Uso: py-venv <python_version>"
    return 1
  fi
  pyenv install -s "$1"
  pyenv virtualenv "$1" venv-"$1"
  pyenv activate venv-"$1"
}

# @desc: Checa flake8/black/mypy
alias pycheck="flake8 . && black --check . && mypy ."

# @desc: Aplica black e isort
alias pyfix="black . && isort ."
