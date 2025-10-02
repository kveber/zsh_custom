# Help aggregator: zhelp (supports @desc and @cat)

zhelp() {
  emulate -L zsh -o no_xtrace -o no_verbose
  local pattern
  pattern="${1-}"

  local -a files
  files=(~/.zsh_custom/*.zsh(.N))

  if (( ${#files} == 0 )); then
    echo "Nenhum arquivo .zsh encontrado em ~/.zsh_custom"
    return 0
  fi

  # Collect entries as: category|name|type|desc|file
  local IFS=$'\n'
  local -a entries
  for f in ${files[@]}; do
    entries+=( $(
      awk -v FILE="$f" -v BASE="${f:t:r}" '
        function trim(s){ sub(/^\s+/,"",s); sub(/\s+$/,"",s); return s }
        BEGIN { last_comment=""; last_desc=""; last_ann=""; last_cat="" }
        {
          line=$0
          if (line ~ /^\s*#/) {
            c=line
            sub(/^\s*#\s?/, "", c)
            if (c ~ /^@desc[ :]/) {
              sub(/^@desc[ :]+/, "", c)
              last_ann=c
            } else if (c ~ /^@cat(egory)?[ :]/) {
              sub(/^@cat(egory)?[ :]+/, "", c)
              last_cat=c
            } else if (trim(c) != "") {
              last_comment=c
            }
            next
          }
          if (trim(line) == "") { last_comment=""; last_ann=""; next }

          # alias NAME=
          if (line ~ /^\s*alias[\t ]+[A-Za-z0-9_:-]+=/) {
            name=line
            sub(/^\s*alias[\t ]+/, "", name)
            sub(/=.*/, "", name)
            desc=(last_ann != "" ? last_ann : last_comment)
            if (desc == "") desc="(alias)"
            cat=(last_cat != "" ? last_cat : BASE)
            printf "%s|%s|alias|%s|%s\n", cat, name, desc, FILE
            last_comment=""; last_ann=""
            next
          }

          # function NAME() {
          if (line ~ /^[A-Za-z0-9_-][A-Za-z0-9_-]*\s*\(\)\s*\{/) {
            name=line
            sub(/\(.*/, "", name)
            name=trim(name)
            desc=(last_ann != "" ? last_ann : last_comment)
            if (desc == "") desc="(função)"
            cat=(last_cat != "" ? last_cat : BASE)
            printf "%s|%s|função|%s|%s\n", cat, name, desc, FILE
            last_comment=""; last_ann=""
            next
          }
        }
      ' "$f"
    ) )
  done

  if (( ${#entries} == 0 )); then
    echo "Nenhum comando encontrado. Adicione comentários com '# @desc: ...' acima de funções/aliases."
    return 0
  fi

  # Header
  printf "%s\n" "Comandos disponíveis (zhelp [filtro]):"

  # Sort, optional filter, and print grouped by category
  if [[ -n "$pattern" ]]; then
    printf "%s\n" ${entries[@]} \
    | grep -i -- "$pattern" \
    | sort -t '|' -k1,1 -k2,2 \
    | awk -F'\|' '
        BEGIN { current="" }
        {
          cat=$1; name=$2; type=$3; desc=$4;
          if (cat!=current) { current=cat; printf "\n[%s]\n", cat }
          printf "  %-20s %-8s %s\n", name, "("type")", desc
        }'
  else
    printf "%s\n" ${entries[@]} \
    | sort -t '|' -k1,1 -k2,2 \
    | awk -F'\|' '
        BEGIN { current="" }
        {
          cat=$1; name=$2; type=$3; desc=$4;
          if (cat!=current) { current=cat; printf "\n[%s]\n", cat }
          printf "  %-20s %-8s %s\n", name, "("type")", desc
        }'
  fi
}


