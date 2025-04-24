{
  description = "boring nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:nix-darwin/nix-darwin/master";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = { pkgs, ... }: {
      environment.systemPackages =
        [ 
          pkgs.ffmpeg-full
          pkgs.git
          pkgs.imagemagick
          pkgs.jq
          pkgs.ripgrep
          pkgs.tmux
          pkgs.vim
        ];

      programs.direnv.enable = true;

      programs.zsh = {
        enable = true;
        enableCompletion = false;
      };

      programs.vim = { 
        enable = true;
        vimConfig =
          ''
            set number
            set relativenumber
            set tabstop=4
            set shiftwidth=4
            set expandtab
            set smartindent
            set nowrap
            set scrolloff=5
          '';
      };

      programs.tmux = {
        enable  = true;
        enableSensible = true;
        enableVim = true;
      };

      nix.settings.experimental-features = "nix-command flakes";
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
