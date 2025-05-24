{
  description = "Dotfiles";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";


    # NixGL for GPU apps.
    # Need to use open PR cause master is broken for Ubuntu 24.10+
    # https://github.com/nix-community/nixGL/issues/199
    nixgl.url = "github:nix-community/nixGL/pull/187/head";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, nixgl, ... }@inputs: {
    # Standalone home-manager configuration entrypoint
    # Available through 'home-manager --flake .#your-username@your-hostname'
    homeConfigurations = {
      "anthony" = home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          config.allowUnfreePredicate = _: true;
        };
        extraSpecialArgs = {
          inherit inputs; # Pass flake inputs to our config
          inherit nixgl;
        };
        # > Our main home-manager configuration file <
        modules = [ ./home.nix ];
      };
    };
  };
}
