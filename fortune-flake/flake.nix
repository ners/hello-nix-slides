{
  inputs.nixpkgs.url = github:nixos/nixpkgs;

  outputs = inputs:
    let
      system = "x86_64-linux";
      pkgs = inputs.nixpkgs.legacyPackages.${system};
    in
    {
      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = [ pkgs.fortune pkgs.cowsay ];
      };
    };
}
