{
  description = "rags and thatch";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment = {
        systemPackages =
          [
            pkgs.git
            pkgs.jq
            pkgs.neovim
            pkgs.pyright
            pkgs.python3
            pkgs.ripgrep
            (pkgs.runCommand "vim-shadow" { } ''
              mkdir -p $out/bin
              ln -s ${pkgs.neovim}/bin/nvim $out/bin/vim
            '') 
          ];
      };
      programs = {
        direnv.enable = true;
        tmux = {
          enable = true;
          enableSensible = true;
          enableVim = true;
        };
      };
      homebrew = {
       enable = true;
       global = { autoUpdate = false; };
       onActivation = {
         cleanup = "zap";
         autoUpdate = true;
         upgrade = true;
       };
       masApps = {
         "Things 3" = 904280696;
         "Vimari" = 1480933944;
         "Xcode" = 497799835;
         "uBlock Origin Lite" = 6745342698;
       };
       brews = [ "cask" ];
       casks =
         [
           "anki"
           "claude-code"
           "little-snitch"
           "netnewswire"
         ];
       };
      system = {
        primaryUser = "lee";
        defaults = {
          dock = {
            autohide = true;
            autohide-delay = 0.0;
            autohide-time-modifier = 0.0;
            orientation = "bottom";
            show-recents = false;
          };
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            ShowPathbar = true;
          };
          NSGlobalDomain = {
            AppleFontSmoothing = 0;
            AppleKeyboardUIMode = 3;
            AppleScrollerPagingBehavior = true;
            InitialKeyRepeat = 10;
            KeyRepeat = 2;
            NSAutomaticSpellingCorrectionEnabled = false;
            NSAutomaticWindowAnimationsEnabled = false;
            NSWindowResizeTime = 0.0;
            _HIHideMenuBar = false;
            "com.apple.sound.beep.feedback" = 0;
            "com.apple.trackpad.scaling" = 2.0;};
        };
      };
      nix.optimise.automatic = true;
      nix.settings.experimental-features = [ "nix-command" "flakes" ];
      system.configurationRevision = self.rev or self.dirtyRev or null;
      system.stateVersion = 6;
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # configuration will run based on default hostname if none is specified
    darwinConfigurations."Lees-MacBook-Air" = nix-darwin.lib.darwinSystem {
      modules = [ configuration ];
    };
  };
}
