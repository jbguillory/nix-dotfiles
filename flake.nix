{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-vscode-extensions = {
      url = "github:nix-community/nix-vscode-extensions";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    lazyvim = {
      url = "github:pfassina/lazyvim-nix";
    };
    twofctl = {
      url = "git+https://code.il2.gamewarden.io/gamewarden/platform/2fctl.git";
    };
  };

  outputs =
    inputs@{
      self,
      twofctl,
      nix-darwin,
      nixpkgs,
      home-manager,
      nix-vscode-extensions,
      lazyvim,
    }:
    let
      programs.zsh.enable = true;

      configuration =
        { pkgs, ... }:
        {
          environment.systemPackages = with pkgs; [
            direnv
            sshs
            glow
            nushell
            carapace
            obsidian
            google-chrome
            brave
            direnv
            go
            python3
            age
            dive
            nodejs
            sops
            talosctl
            talhelper
            terraform
            trivy
            sketchybar
            awscli2
            go-task
            pkgs.twofctl
          ];
          nix.settings.experimental-features = "nix-command flakes";
          programs.zsh.enable = true;
          system.configurationRevision = self.rev or self.dirtyRev or null;
          system.stateVersion = 4;
          nixpkgs.hostPlatform = "aarch64-darwin";
          users.users."john.guillory".home = "/Users/john.guillory";
          home-manager.backupFileExtension = "backup";
          ids.gids.nixbld = 350;
          system.primaryUser = "john.guillory";
          nixpkgs.config.allowUnfree = true;

          system.defaults = {
            dock.autohide = true;
            dock.mru-spaces = false;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            dock.persistent-apps = [
              "/System/Applications/Launchpad.app"
              "/Applications/Spotify.app"
              "/Applications/Slack.app"
              "/Applications/Firefox.app"
              "${pkgs.brave}/Applications/Brave Browser.app"
              "${pkgs.google-chrome}/Applications/Google Chrome.app"
              "/Applications/Gather.app"
              "${pkgs.obsidian}/Applications/Obsidian.app"
              "${pkgs.vscode}/Applications/Visual Studio Code.app"
              "/Applications/kitty.app"
              "/System/Applications/Mail.app"
              "/System/Applications/Calendar.app"
            ];
            screencapture.location = "~/Pictures/screenshots";
          };

          homebrew = {
            enable = true;
            casks = [
              "nikitabobko/tap/aerospace"
              "firefox"
              "bitwarden"
              "docker"
              "font-fira-code"
              "font-fira-code-nerd-font"
              "font-victor-mono-nerd-font"
              "font-roboto-mono-nerd-font"
              "gather"
              "google-chrome"
              "google-drive"
              "kitty"
              "slack"
              "spotify"
              "sf-symbols"
              "appgate-sdp-client"
              "adobe-acrobat-reader"
              "visual-studio-code"
              "claude-code"
            ];
            brews = [
              "atuin"
              "asdf"
              "bat"
              "bitwarden-cli"
              "bash"
              "curl"
              "direnv"
              "eza"
              "fzf"
              "git"
              "glab"
              "glow"
              "jq"
              "jp2a"
              "k9s"
              "mpv"
              "neofetch"
              "nnn"
              "pastel"
              "poppler"
              "ripgrep"
              "spotify_player"
              "starship"
              "tmux"
              "tmuxinator"
              "trash-cli"
              "zsh"
              "nvim"
              "helm"
              "helmfile"
              "fluxcd/tap/flux"
              "krew"
              "displayplacer"
              "kubernetes-cli"
              "kubelogin"
              "pulumi"
              "python"
              "wget"
              "kustomize"
              "hashicorp/tap/vault"
            ];
            taps = [
              "nikitabobko/tap"
              "koekeishiya/formulae"
              "smudge/smudge"
              "FelixKratz/formulae"
              "hashicorp/tap"
              "fluxcd/tap"
            ];
            onActivation.cleanup = "uninstall";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };
        };
    in
    {
      darwinConfigurations."MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        pkgs = import nixpkgs {
          system = "aarch64-darwin";
          config.allowUnfree = true;
          overlays = [ twofctl.overlays.default ];
        };
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users."john.guillory" = import ./home/home.nix;
            home-manager.sharedModules = [ lazyvim.homeManagerModules.lazyvim ];
            home-manager.extraSpecialArgs = { inherit inputs; };
            nix.enable = false;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."MacBook-Pro".pkgs;
    };
}