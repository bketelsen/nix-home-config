{ config, lib, pkgs, ... }:
let

  # Import other Nix files
  imports = [
    ../../arch/linux/home.nix
    ../../program/git/git.nix
    ../../program/editor/neovim.nix
    ../../program/terminal/tmux.nix
  ];

in
{
  inherit imports;

}
