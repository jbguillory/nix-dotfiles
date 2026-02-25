{ pkgs, inputs, nur, ... }:
let
  nurPkgs = import nur { inherit pkgs; nurpkgs = pkgs; };
in
{
  programs.firefox = {
    enable = true;
    profiles.default = {
      extensions.packages = with nurPkgs.repos.rycee.firefox-addons; [
        ublock-origin
        darkreader
      ];
    };
  };
}