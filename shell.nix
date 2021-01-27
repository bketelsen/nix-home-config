# Shell configuration for zsh (frequently used) and fish (used just for fun)

{ config, lib, pkgs, ... }:

let
  # Set all shell aliases programatically
  shellAliases = {
    # Aliases for commonly used tools
    grep = "grep --color=auto";
    just = "just --no-dotenv";
    diff = "diff --color=auto";
    cat = "bat";
    we = "watchexec";
    find = "fd";
    cloc = "tokei";
    l = "exa";
    ll = "ls -lh";
    ls = "exa";
    k = "kubectl";
    dc = "docker-compose";
    md = "mdcat";
    tf = "terraform";
    hms = "home-manager switch";

    # Reload zsh
    szsh = "source ~/.zshrc";

    # Reload home manager and zsh
    reload = "home-manager switch && source ~/.zshrc";

    # Nix garbage collection
    garbage = "nix-collect-garbage -d && docker image prune --force";

    # See which Nix packages are installed
    installed = "nix-env --query --installed";
  };
in {
  # Fancy filesystem navigator
  programs.broot = {
    enable = true;
    enableZshIntegration = true;
  };


  #programs.fzf = {
  #  enable = true;
  #  enableBashIntegration = true;
  #  defaultCommand = "${pkgs.ripgrep}/bin/rg --files";
  #};

  # zsh settings
  programs.zsh = {
    inherit shellAliases;
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;
    history.extended = true;

    # Called whenever zsh is initialized
    initExtra = ''
      export TERM="xterm-256color"
      bindkey -e

      # Nix setup (environment variables, etc.)
      if [ -e ~/.nix-profile/etc/profile.d/nix.sh ]; then
        . ~/.nix-profile/etc/profile.d/nix.sh
      fi

      # Load environment variables from a file; this approach allows me to not
      # commit secrets like API keys to Git
      if [ -e ~/.env ]; then
        . ~/.env
      fi

      # Start up Starship shell
      eval "$(starship init zsh)"

      # Autocomplete for various utilities
      #source <(helm completion zsh)
      source <(kubectl completion zsh)
      source <(gh completion --shell zsh)
      #rustup completions zsh > ~/.zfunc/_rustup
      source <(npm completion zsh)

      # direnv setup
      eval "$(direnv hook zsh)"

      # Load asdf
      #. $HOME/.asdf/asdf.sh

      # direnv hook
      eval "$(direnv hook zsh)"
    '';

    # Disable oh my zsh in favor of Starship shell
    #oh-my-zsh = {
    #  enable = true;
    #  plugins = [
    #    "docker"
    #    "docker-compose"
    #    "dotenv"
    #    "git"
    #    "sudo"
    #  ];
    #  theme = "muse";
    #};
  };
}
