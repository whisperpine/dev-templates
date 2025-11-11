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
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              husky # managing git hooks
              typos # check misspelling
              cocogitto # conventional commit toolkit
              just # just a command runner
            ];
            # The shell script executed when the environment is activated.
            shellHook = ''
              # Print the last modified date of "flake.lock".
              stat flake.lock | grep "Modify" |
                awk '{printf "\"flake.lock\" last modified on: %s", $2}' &&
                echo " ($((($(date +%s) - $(stat -c %Y flake.lock)) / 86400)) days ago)"
              # Install git hook managed by husky.
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

        web = {
          path = ./web;
          description = "Web frontend development environment";
        };
      };
    };
}
