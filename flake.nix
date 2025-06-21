{
  description = "Ready-made templates for easily creating flake-driven environments";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system: f { pkgs = import inputs.nixpkgs { inherit system; }; }
        );
    in
    {
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShell {
            packages = with pkgs; [
              husky
              typos
            ];
            shellHook = ''
              # install git hook managed by husky
              if [ ! -e "./.husky/_" ]; then
                husky install
              fi
            '';
          };
        }
      );

      templates = rec {
        default = empty;

        empty = {
          path = ./empty;
          description = "Empty development environment";
        };

        rust = {
          path = ./rust;
          description = "Rust development environment";
        };

        python = {
          path = ./python;
          description = "Python development environment";
        };
      };
    };
}
