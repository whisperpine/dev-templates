{
  description = "A Nix-flake-based development environment";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  outputs =
    inputs:
    let
      goVersion = 24; # change this to update go version
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forEachSupportedSystem =
        f:
        inputs.nixpkgs.lib.genAttrs supportedSystems (
          system:
          f {
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [ inputs.self.overlays.default ];
            };
          }
        );
    in
    {
      overlays.default = final: prev: { go = final."go_1_${toString goVersion}"; };
      devShells = forEachSupportedSystem (
        { pkgs }:
        {
          default = pkgs.mkShellNoCC {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              go # go (version is specified by overlay)
              gotools # goimports, godoc, etc.
              just # just a command runner
            ];
            # The shell script executed when the environment is activated.
            shellHook = ''
              # Print the last modified date of "flake.lock".
              stat flake.lock | grep "Modify" |
                awk '{printf "\"flake.lock\" last modified on: %s", $2}' &&
                echo " ($((($(date +%s) - $(stat -c %Y flake.lock)) / 86400)) days ago)"
            '';
          };
        }
      );
    };
}
