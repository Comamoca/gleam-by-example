{
  description = "A basic flake to with Gleam language";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    treefmt-nix.url = "github:numtide/treefmt-nix";
    flake-parts.url = "github:hercules-ci/flake-parts";
    systems.url = "github:nix-systems/default";
    git-hooks-nix.url = "github:cachix/git-hooks.nix";
    devenv.url = "github:cachix/devenv";
    gleam-overlay.url = "github:Comamoca/gleam-overlay";
    gleam2nix.url = "git+https://git.isincredibly.gay/srxl/gleam2nix";
    gleam2nix.inputs.nixpkgs.follows = "nixpkgs";
    deno-overlay.url = "github:haruki7049/deno-overlay";
    fenix.url = "github:nix-community/fenix";
  };

  outputs =
    inputs@{
      self,
      systems,
      nixpkgs,
      flake-parts,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.treefmt-nix.flakeModule
        inputs.git-hooks-nix.flakeModule
        inputs.devenv.flakeModule
      ];
      systems = import inputs.systems;

      perSystem =
        {
          config,
          pkgs,
          system,
          ...
        }:
        let
          stdenv = pkgs.stdenv;

          app = pkgs.buildGleamApplication {
            pname = "hello";
            version = "1.0.0";
            src = pkgs.lib.cleanSource ./.;
            gleamNix = import ./gleam.nix { inherit (pkgs) lib; };
            gleam = pkgs.gleam.bin.latest;
          };

          use-only-nix = with pkgs; [
            nil
            gleam2nix
            devcontainer
          ];

          devdeps-gleam = with pkgs; [
            pkgs.gleam.bin.latest
            beam28Packages.rebar3
            beam28Packages.erlang
            nodejs
	    wrangler
          ];

          devShellImage = pkgs.dockerTools.buildImage {
            name = "devShellImage";
            fromImage = pkgs.dockerTools.pullImage {
              imageName = "debian";
              imageDigest = "sha256:dff4def4601f20ccb9422ad7867772fbb13019fd186bbe59cd9fc28a82313283";
              hash = "sha256-Qrv4Re0Xy13+oh6IA2lXcOAxq8YjKLf7nyjoFLouiOI=";
              finalImageName = "debian";
              finalImageTag = "stable";
            };

            copyToRoot = pkgs.buildEnv {
              name = "image-root";
              paths = devdeps-gleam ++ [
                (pkgs.runCommand "bin-sh-link" {} ''
                  mkdir -p $out/bin
                  ln -s /usr/bin/dash $out/bin/sh
                '')
              ];
              pathsToLink = [ "/bin" ];
            };
            config = {
              Env = [ "SSL_CERT_FILE=${pkgs.cacert}/etc/ssl/certs/ca-bundle.crt" ];
            };
          };
        in
        {
          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.gleam-overlay.overlays.default
              inputs.gleam2nix.overlays.default
              inputs.fenix.overlays.default
              inputs.deno-overlay.overlays.deno-overlay
            ];
            config = { };
          };

          treefmt = {
            projectRootFile = "flake.nix";
            programs = {
              nixfmt.enable = true;
            };

            settings.formatter = { };
          };

          pre-commit = {
            check.enable = true;
            settings = {
              hooks = {
                treefmt.enable = true;
                gitleaks = {
                  enable = true;
                  entry = "${pkgs.gitleaks}/bin/gitleaks protect --staged";
                  language = "system";
                };
                gitlint.enable = true;
              };
            };
          };

          devenv.shells.default = {
            packages = use-only-nix ++ devdeps-gleam;

            services.postgres = {
              enable = true;
              listen_addresses = "127.0.0.1";
              port = 5432;
              package = pkgs.postgresql_18;

              initialDatabases = [ { name = "app"; } ];
              initialScript = ''
                CREATE USER postgres SUPERUSER;
              '';
            };
            enterShell = '''';
          };

          packages = {
            dockerImage = devShellImage;
          };
        };
    };
}
