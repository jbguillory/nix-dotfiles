{ config, pkgs, lib, inputs, ... }:
{
  imports = [
    ./vscode/vscode.nix
    ./zsh/zsh.nix
    ./firefox/firefox.nix
  ];

  home.username = "john.guillory";
  home.homeDirectory = "/Users/john.guillory";
  home.stateVersion = "23.05";
  home.packages = [];

  home.file = {
    ".config/zsh".source = ./zsh;
    ".config/atuin".source = ./atuin;
    ".config/kitty".source = ./kitty;
    ".zshenv".source = ./zsh/.zshenv;
    ".config/nix".source = ./nix;
    ".config/k9s".source = ./k9s;
    ".config/aerospace".source = ./aerospace;
    ".config/sketchybar".source = ./sketchybar;
    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore".source = ./git/.gitignore;
    ".gitmessage".source = ./git/.gitmessage;
    "workspace/.gitconfig-2F".source = ./git/.gitconfig-2F;
    "workspace/.gitconfig-2Fgit".source = ./git/.gitconfig-2F;
  };

  programs.lazyvim = {
    enable = true;
    extras = {
      lang.docker.enable = true;
    };
  };

  home.activation.systemDarkMode = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /usr/bin/defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
  '';
  home.activation.mouseSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  '';
  home.activation.notificationSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /usr/bin/defaults write com.apple.notificationcenterui NSUserNotificationAlertStyle -string "banner"
    /usr/bin/killall NotificationCenter 2>/dev/null || true
  '';
  home.activation.nixConfig = lib.hm.dag.entryAfter ["writeBoundary"] ''
    if ! grep -q "netrc-file" ~/.config/nix/nix.conf 2>/dev/null; then
      echo "netrc-file = /Users/john.guillory/.netrc" >> ~/.config/nix/nix.conf
    fi
  '';
  home.activation.createAwsDir = lib.hm.dag.entryAfter ["writeBoundary"] ''
    mkdir -p ~/.aws
  '';

  home.sessionVariables = {
    GPG_TTY = "$(tty)";
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.home-manager.enable = true;
}