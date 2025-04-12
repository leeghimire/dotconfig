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
	  pkgs.direnv
	  pkgs.git
	  pkgs.imagemagick
	  pkgs.jq
	  pkgs.vim
          pkgs.ripgrep
          pkgs.tmux
        ];

      programs.tmux.enable = true;
      programs.tmux.enableSensible = true;
      programs.tmux.enableVim = true;

      programs.vim.enable = true;
      programs.vim.vimConfig = ''
          set clipboard=unnamedplus
          set number
          set relativenumber
          set tabstop=4
          set shiftwidth=4
          set expandtab
          set smartindent
          set nowrap
          set scrolloff=5
        '';

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
