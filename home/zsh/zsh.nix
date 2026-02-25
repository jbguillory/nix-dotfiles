{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_BIN_HOME="$HOME/.local/bin"
    '';
    initContent = ''
      eval "$(/opt/homebrew/bin/brew shellenv)"
      eval "$(zoxide init zsh)"
      # Navigation
      setopt AUTO_CD
      setopt AUTO_PUSHD
      setopt PUSHD_IGNORE_DUPS
      setopt PUSHD_SILENT
      setopt CORRECT
      setopt CDABLE_VARS
      setopt EXTENDED_GLOB

      # History
      setopt EXTENDED_HISTORY
      setopt SHARE_HISTORY
      setopt INC_APPEND_HISTORY
      setopt HIST_EXPIRE_DUPS_FIRST
      setopt HIST_IGNORE_DUPS
      setopt HIST_IGNORE_ALL_DUPS
      setopt HIST_FIND_NO_DUPS
      setopt HIST_IGNORE_SPACE
      setopt HIST_SAVE_NO_DUPS
      setopt HIST_VERIFY

      # Aliases
      source ~/.config/zsh/aliases

      # Functions
      autoload -Uz ~/.config/zsh/functions/*

      # FZF
      if [ $(command -v "fzf") ]; then
        source $(brew --prefix fzf)/shell/completion.zsh
        source $(brew --prefix fzf)/shell/key-bindings.zsh
      fi

      # Direnv
      eval "$(direnv hook zsh)"

      # Prompt
      eval "$(starship init zsh)"

      # Atuin
      eval "$(atuin init zsh)"

      # Flux completion
      autoload -Uz compinit
      compinit
      command -v flux >/dev/null && . <(flux completion zsh)
    '';
  };
}