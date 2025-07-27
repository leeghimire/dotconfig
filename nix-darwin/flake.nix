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
            pkgs.llvm
            pkgs.neovim
            pkgs.pyright
            pkgs.ripgrep
            pkgs.zig
            pkgs.zls

            (pkgs.runCommand "vim-shadow" { } ''
              mkdir -p $out/bin
              ln -s ${pkgs.neovim}/bin/nvim $out/bin/vim
            '') 
          ];
      };
      programs = {
        direnv.enable = true;
        tmux = {
          enable         = true;
          enableSensible = true;
          enableVim      = true;
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
             "netnewswire"
             "obsidian"
             "zotero"
           ];
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
