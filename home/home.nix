# home.nix
# home-manager switch

{ config, pkgs, lib, ... }:
{
  imports = [
    ./vscode/vscode.nix
    ./zsh/zsh.nix
    ./firefox/firefox.nix
  ];


  home.username = "john.guillory";
  home.homeDirectory = "/Users/john.guillory";
  home.stateVersion = "23.05"; # Please read the comment before changing.

  # Makes sense for user specific applications that shouldn't be available system-wide
  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".config/zsh".source = ./zsh;
    ".config/atuin".source = ./atuin;
    ".config/kitty".source = ./kitty;
    ".zshenv".source = ./zsh/.zshenv;
    # ".config/nvim".source = ./nvim;
    ".config/nvim/init.lua".source = ./nvim/init.lua;
    ".config/nvim/lua".source = ./nvim/lua;
    # ".config/nvim/after".source = ./nvim/after;
    ".config/nix".source = ./nix;
    ".config/k9s".source = ./k9s;
    ".config/aerospace".source = ./aerospace;
    ".config/sketchybar".source = ./sketchybar;

    # git
    ".gitconfig".source = ./git/.gitconfig;
    ".gitignore".source = ./git/.gitignore;
    ".gitmessage".source = ./git/.gitmessage;
    "workspace/.gitconfig-2F".source = ./git/.gitconfig-2F;
    "workspace/.gitconfig-2Fgit".source = ./git/.gitconfig-2F;
  };

  home.sessionVariables = {
    GPG_TTY = "$(tty)";
  };
  # disable mouse inversion
  home.activation.mouseSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    /usr/bin/defaults write NSGlobalDomain com.apple.swipescrolldirection -bool false
  '';
  # temporary banner notificationSettings
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
  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];
  programs.home-manager.enable = true;

}