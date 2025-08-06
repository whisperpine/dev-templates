{
  description = "A Nix-flake-based development environment";
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
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              # For example:
              typos
            ];
            # Environment variables taking effect in the dev environment.
            env = {
              # For example:
              GREETING = "Hello, Nix!";
            };
            # The shell script executed when the environment is activated.
            shellHook = ''
              # For example:
              echo "### nix develop environment is activated ###"
            '';
          };
        }
      );
    };
}
