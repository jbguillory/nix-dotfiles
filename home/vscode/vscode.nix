{ pkgs, lib, inputs, ... }:
let
  vscode-marketplace = inputs.nix-vscode-extensions.extensions.${pkgs.system}.vscode-marketplace;
in
{
  home.packages = [ pkgs.nil ];
  programs.vscode = {
    enable = true;
    profiles.default = {
      extensions = with vscode-marketplace; [
        asvetliakov.vscode-neovim
      ];
      userSettings = {
        "editor.lineNumbers" = "relative";
        "files.autoSave" = "afterDelay";
        "files.autoSaveDelay" = 1000;
      };
    };
  };
}