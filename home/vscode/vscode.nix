{ config, pkgs, ... }:
{
  programs.vscode = {
    enable = true;
    profiles.default.userSettings = {
      "files.autoSave" = "afterDelay";
      "files.autoSaveDelay" = 1000;
    };
  };
}