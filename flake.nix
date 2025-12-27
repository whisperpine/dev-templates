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
          default = pkgs.mkShellNoCC {
            # The Nix packages installed in the dev environment.
            packages = with pkgs; [
              husky # managing git hooks
              typos # check misspelling
              cocogitto # conventional commit toolkit
            ];
            # The shell script executed when the environment is activated.
            shellHook = /* sh */ ''
              # Print the last modified date of "flake.lock".
              git log -1 --format="%cd" --date=format:"%Y-%m-%d" -- flake.lock |
                awk '{printf "\"flake.lock\" last modified on: %s", $1}' &&
                echo " ($((($(date +%s) - $(git log -1 --format="%ct" -- flake.lock)) / 86400)) days ago)"
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

        golang = {
          path = ./golang;
          description = "Go development environment";
        };
      };
    };
}
