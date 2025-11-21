# Introduction 

These are my basic configurations for kitty and neovim.

## kitty

1. Install
   ```bash
   curl -L https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin
   ```
2. Copy the `kitty.conf` configuration file to the `~/.config/kitty` folder.

## neovim configuration 

1. Install [neovim](https://github.com/neovim/neovim/blob/master/INSTALL.md#linux)
   ```bash  
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim-linux-x86_64
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz
    ```

2. Create the config folder
   ```bash
   mkdir -p ~/.config/nvim
   ```

4. Install the Plugin manager [vim-plug](https://github.com/junegunn/vim-plug)
   ```bash
    sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    ```
   
5. Install pyright
   ```bash
   sudo apt-get update -y && sudo apt-get install -y nodejs npm # if you do not have already node installed
   npm i -g pyright
   ```
   
6. Install gopls
   ```bash
   go install golang.org/x/tools/gopls@latest
   ```

7. Install terraform-ls
   

9.  Copy the lua.init to the `~/.config/nvim` folder
