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
        systemPackages = [ pkgs.git pkgs.jq pkgs.ripgrep ];
        shellAliases = {
          code = "windsurf";
        };
      };
      programs = {
        direnv.enable = true;
        tmux = {
          enable         = true;
          enableSensible = true;
          enableVim      = true;
        };
        vim = {
          enable         = true;
          enableSensible = true;
          vimConfig = "set rnu";
        };
      };
      homebrew = {
       enable = true;
       global = { autoUpdate = false; };
         onActivation = {
           cleanup = "zap";
           autoUpdate = false;
           upgrade = false;
         };
         casks =
           [
             "anki"
             "little-snitch"
             "obsidian"
             "windsurf"
             "zotero"
           ];
      };
      system = {
        primaryUser = "leeghimire";
        defaults = {
          dock = {
            autohide = true;
            show-recents = false;
          };
          finder = {
            AppleShowAllExtensions = true;
            AppleShowAllFiles = true;
            ShowPathbar = true;
          };
            AppleFontSmoothing = 0;
            AppleInterfaceStyle = "Dark";
            InitialKeyRepeat = 10;
            KeyRepeat = 2;
            _HIHideMenuBar = false;
            "com.apple.sound.beep.feedback" = 0;
          };
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
