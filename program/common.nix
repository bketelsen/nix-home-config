{ config, lib, pkgs, imports,... }:

let

  # Handly shell command to view the dependency tree of Nix packages
  depends = pkgs.writeScriptBin "depends" ''
    dep=$1
    nix-store --query --requisites $(which $dep)
  '';


  git-hash = pkgs.writeScriptBin "git-hash" ''
    nix-prefetch-url --unpack https://github.com/$1/$2/archive/$3.tar.gz
  '';

  wo = pkgs.writeScriptBin "wo" ''
    readlink $(which $1)
  '';

  run = pkgs.writeScriptBin "run" ''
    nix-shell --pure --run "$@"
  '';

  hugoLocal = pkgs.callPackage ../hugo/hugo.nix {
    hugoVersion = "0.80.0";
    sha = "0rikr4yrjvmrv8smvr8jdbcjqwf61y369wn875iywrj63pyr74r9";
    vendorSha = "031k8bvca1pb1naw922vg5h95gnwp76dii1cjcs0b1qj93isdibk";
  };

  scripts = [
    depends
    git-hash
    run
    wo
  ];

  pythonPackages = with pkgs.python38Packages; [
    pip
    requests
    setuptools
  ];


  gitTools = with pkgs.gitAndTools; [
    delta
    diff-so-fancy
    git-codeowners
    gitflow
    gh
  ];

in {
  inherit imports;
  # Allow non-free (as in beer) packages
  nixpkgs.config = {
    allowUnfree = true;
    allowUnsupportedSystem = true;
  };

  # Enable Home Manager
  programs.home-manager.enable = true;


  # Golang
  programs.go.enable = true;

  home.sessionVariables = {
    EDITOR = "nvim";
    TERMINAL = "alacritty";
  };

  # Miscellaneous packages (in alphabetical order)
  home.packages = with pkgs; [
    autoconf # Broadly used tool, no clue what it does
    awscli # Amazon Web Services CLI
    azure-cli # Azure is where the heart is
    bash # /bin/bash
    bat # cat replacement written in Rust
    buildpack # Cloud Native buildpacks
    buildkit # Fancy Docker
    cachix # Nix build cache
    cargo-edit # Easy Rust dependency management
    cargo-graph # Rust dependency graphs
    cargo-watch # Watch a Rust project and execute custom commands upon change
    curl # An old classic
    direnv # Per-directory environment variables
    docker-compose # Local multi-container Docker environments
    exa # ls replacement written in Rust
    fd # find replacement written in Rust
    fluxctl # GitOps operator
    fzf # Fuzzy finder
    graphviz # dot
    gnupg # gpg
    htop # Resource monitoring
    httpie # Like curl but more user friendly
    hugoLocal # Best static site generator ever
    jq # JSON parsing for the CLI
    just # Intriguing new make replacement
    kubectl # Kubernetes CLI tool
    kubectx # kubectl context switching
    lorri # Easy Nix shell
    mdcat # Markdown converter/reader for the CLI
    niv # Nix dependency management
    nix-serve
    nixos-generators
    nodejs # node and npm
    pre-commit # Pre-commit CI hook tool
    protobuf # Protocol Buffers
    python3 # Have you upgraded yet???
    ripgrep # grep replacement written in Rust
    rustup # Rust dev environment management
    sd # Fancy sed replacement
    skim # High-powered fuzzy finder written in Rust
    spotify-tui # Spotify interface for the CLI
    starship # Fancy shell that works with zsh
    tealdeer # tldr for various shell tools
    terraform # Declarative infrastructure management
    tokei # Handy tool to see lines of code by language
    tree # Should be included in macOS but it's not
    vgo2nix # Package Go modules projects
    vscode # My fav text editor if I'm being honest
    wget
    watchexec # Fileystem watcher/executor useful for speedy development
    wrangler # CloudFlare Workers CLI tool
    yarn # Node.js package manager
    zola # Static site generator written in Rust
  ] ++ gitTools ++ pythonPackages ++ scripts;
}
