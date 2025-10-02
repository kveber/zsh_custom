# zsh_custom

Custom **Zsh scripts and functions** for productivity 🚀  
This repository contains modular `.zsh` files that extend your shell with aliases, functions, and utilities I use daily.  
It’s designed to be **simple to install**, **easy to extend**, and hopefully useful for others too.

---

## 🎯 Overview

- 📁 Organized by topic: Docker, Kubernetes, Python, Node.js, Cloud, etc.  
- 🛠️ Automatic installer (`install.sh`) that hooks into your `.zshrc`.  
- 🧩 Modular design: each `.zsh` file is loaded independently.  

Whether you want shortcuts for Git/Docker, Kubernetes helpers, or Python utilities, you can plug them in without editing your `.zshrc` manually.

---

## 📂 Repository Structure

```text
.
├── install.sh            # Installer script
├── docker.zsh            # Docker aliases and functions
├── k8s.zsh               # Kubernetes helpers
├── node.zsh              # Node.js / npm shortcuts
├── python.zsh            # Python utilities
├── cloud.zsh             # Cloud (AWS/GCP/etc.) helpers
├── utils.zsh             # Generic utility functions
├── functions.zsh         # General functions
└── aliases.zsh           # Global aliases
```

Each .zsh file is automatically loaded by the installer.

⸻

⚡ Installation

1.	Clone the repo:
```shell
git clone https://github.com/kveber/zsh_custom.git ~/.zsh_custom
```

2.	Make the installer executable:
```shell
chmod +x ~/.zsh_custom/install.sh
```

3.	Run the installer:
```shell
~/.zsh_custom/install.sh
```

The script will:
- Add a block to your ~/.zshrc that sources all .zsh files inside ~/.zsh_custom.
- Ensure no duplicates are added.
- Reload your shell.

4.	Reload Zsh immediately:
```shell
source ~/.zshrc
```


⸻

🛠 Usage
- Add new scripts: just drop a new .zsh file inside ~/.zsh_custom.

Example: _~/.zsh_custom/my_aliases.zsh_
```
alias gs='git status -sb'

greet() {
  echo "Hello, $1"
}
```

- Check if loaded:
```
type greet
alias gs
```

- Remove integration:
Edit ~/.zshrc and remove the block that sources ~/.zsh_custom.

⸻

🔄 Load Order
- Files are loaded alphabetically.
- If you need to control order, prefix filenames (01_docker.zsh, 02_k8s.zsh).
- Scripts can also include conditional logic, e.g.:
```
if command -v docker >/dev/null; then
  source ~/.zsh_custom/docker.zsh
fi
```


⸻

✨ Examples

Depending on which files are enabled, you’ll get:
- 🐳 Docker: shortcuts for containers & images
- ☸️ Kubernetes: helper functions for clusters
- 🟢 Node.js: npm/yarn aliases
- 🐍 Python: environment helpers
- ☁️ Cloud: AWS/GCP utilities
- 🔧 Utils: logs, ports, strings, etc.

⸻

🤝 Contributing

Contributions are welcome! Here’s how you can help:
1. Report issues: bugs, typos, missing features.
2. Submit PRs:
- Use descriptive branch names (fix/docker-alias, feature/aws-tools).
- Test before submitting.
- Keep style consistent (indentation, comments).
3. Improve docs: add usage examples, extend this README.
4. Test on multiple systems: Linux, macOS, WSL.
5. Suggest improvements: performance, cross-platform fixes, shell best practices.

⸻

🚀 Future Improvements (Ideas)
- Conditional loading based on available commands.
- Verbose/debug mode to show which files are sourced.
- Add shellcheck linting for cleaner scripts.
- Provide templates for new .zsh modules.
- Release tags & changelog for stable versions.
- Optional plugin manager support (Oh My Zsh, Antigen, etc.).

⸻

📜 License

(Choose a license — e.g., MIT, Apache 2.0, or GPL. If none is specified, it defaults to “all rights reserved.”)

⸻

👤 Author

Kveber
Maintainer and main user of these Zsh customizations.
Feel free to open an issue if you have questions or ideas.
