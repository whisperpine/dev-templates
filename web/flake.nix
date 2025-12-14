{
  description = "A Nix-flake-based web development environment";
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
          default = pkgs.mkShellNoCC {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              biome # linting js and ts
              bun # all-in-one toolkit like nodejs
              just # just a command runner
            ];
            # The shell script executed when the environment is activated.
            shellHook = ''
              # Print the last modified date of "flake.lock".
              stat flake.lock | grep "Modify" |
                awk '{printf "\"flake.lock\" last modified on: %s", $2}' &&
                echo " ($((($(date +%s) - $(stat -c %Y flake.lock)) / 86400)) days ago)"
              # Install packages declared in "package.json".
              bun install
            '';
          };
        }
      );
    };
}
