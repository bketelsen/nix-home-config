# Visual Studio Code settings

{ config, lib, pkgs, ... }:

{
  nixpkgs.config.allowUnfree = true;

  programs.vscode = {
    enable = true;

    package = with pkgs; vscodium;

    userSettings = {
      "workbench.colorTheme" = "GitHub Dark";
    };

    extensions = with pkgs.vscode-extensions; [
      bbenoist.Nix
    ];
  };
}
