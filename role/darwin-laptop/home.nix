{ config, lib, pkgs, ... }:
let

  # Import other Nix files
  imports = [
    ../../arch/darwin/home.nix
    ../../program/git/git.nix
    ../../program/editor/neovim.nix
    ../../program/editor/vscode.nix
    ../../program/terminal/tmux.nix
  ];



in
{
  inherit imports;

}
