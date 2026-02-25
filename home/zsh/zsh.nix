{ pkgs, ... }:
{
  programs.zsh = {
    enable = true;
    syntaxHighlighting.enable = true;
    envExtra = ''
      export ZDOTDIR="$HOME/.config/zsh"
      export XDG_CONFIG_HOME="$HOME/.config"
      export XDG_DATA_HOME="$HOME/.local/share"
      export XDG_CACHE_HOME="$HOME/.cache"
      export XDG_BIN_HOME="$HOME/.local/bin"
    '';
  };
}