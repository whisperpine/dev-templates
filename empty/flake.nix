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
            # The Nix packages provided in the environment.
            packages = with pkgs; [
              # For example:
              typos
            ];
            # Set any environment variables for your dev shell.
            env = {
              # For example:
              GREETING = "Hello, Nix!";
            };
            # Shell which will be executed any time the environment is activated.
            shellHook = ''
              # For example:
              echo "### nix develop environment is activated ###"
            '';
          };
        }
      );
    };
}
