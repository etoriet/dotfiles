dotfiles
========

## Setup

```bash
cd
git clone https://github.com/etoriet/dotfiles.git
cd dotfiles
./setup/dotfiles.sh     # setup dotfile at $HOME directory
source ~/.bash_profile
./setup/brew.sh         # setup CLI tools with brew
./setup/daily.sh        # setup daily logger
```

## Notes on WSL

- homebrewでインストールできないツールがある。`linux.Brewfile`を参照せよ。