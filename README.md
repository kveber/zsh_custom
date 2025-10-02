### Scripts personalizados do Zsh (`~/.zsh_custom`)

**Objetivo**: centralizar aliases e funções em arquivos `.zsh` dentro de `~/.zsh_custom`, carregados automaticamente pelo `~/.zshrc`.

O instalador (`install.sh`) adiciona ao `~/.zshrc` o bloco abaixo (uma única vez) e recarrega a configuração:

```zsh
# Importa funções personalizadas de ~/.zsh_custom
for f in ~/.zsh_custom/*.zsh; do
  source "$f"
done
```

### Instalação

```bash
chmod +x ~/.zsh_custom/install.sh
~/.zsh_custom/install.sh
# para aplicar no shell atual
source ~/.zshrc
```

### Como usar

- **Adicionar scripts**: crie arquivos terminando em `.zsh` dentro de `~/.zsh_custom`.
- **Exemplo** `~/.zsh_custom/meus-aliases.zsh`:

```zsh
alias gs='git status -sb'

minha_funcao() {
  echo "Olá $1"
}
```

- **Aplicar mudanças**:

```bash
source ~/.zshrc   # ou reinicie o terminal
```

- **Verificar carregamento**:

```bash
types minha_funcao
alias gs
```

### Desinstalação (remover o bloco do ~/.zshrc)

```bash
cp ~/.zshrc ~/.zshrc.before_custom.bak
sed -i '' '/# Importa funções personalizadas de ~/.zsh_custom/,+3 d' ~/.zshrc
source ~/.zshrc
```

### Observações

- **Idempotente**: o instalador não duplica o bloco no `~/.zshrc`.
- **Compatibilidade**: se o instalador rodar fora do zsh, ele recarrega o `~/.zshrc` via `zsh` para evitar erros (ex.: `fpath`).
- **Ordem de carregamento**: arquivos são carregados em ordem alfabética; use prefixos numéricos se precisar de ordem explícita.
- **Estrutura sugerida**:

```
~/.zsh_custom/
  install.sh
  aliases.zsh
  functions.zsh
  k8s.zsh
```


