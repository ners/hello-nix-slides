{
  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      devShells.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.gcc ];
      };
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "hello";
        version = "0.0.1";
        src = ./.;
        makeFlags = [ "BINDIR=$(out)/bin" ];
      };
    }
  );
}

