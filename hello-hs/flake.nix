{
  inputs.nixpkgs.url = github:nixos/nixpkgs;
  inputs.flake-utils.url = github:numtide/flake-utils;

  outputs = inputs: inputs.flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = inputs.nixpkgs.legacyPackages.${system};
      hello = pkgs.haskellPackages.callCabal2nix "hello" ./. { };
    in
    {
      packages.default = hello;
      packages.oci-image = pkgs.dockerTools.buildLayeredImage {
        name = hello.pname;
        contents = [ hello ];
        tag = "latest";
        config.Cmd = [ hello.meta.mainProgram ];
      };
      packages.test = pkgs.nixosTest {
        name = "server-says-hello";
        nodes = {
          server = {
            networking.firewall.allowedTCPPorts = [ 3000 ];
            systemd.services.hello = {
              wantedBy = [ "multi-user.target" ];
              script = "${hello}/bin/hello";
            };
          };
          client = { environment.systemPackages = [ pkgs.curl ]; };
        };
        testScript = ''
          start_all()
          server.wait_for_open_port(3000)
          expected = "Hello Haskell!";
          actual = client.succeed("curl http://server:3000")
          assert expected == actual, "server says hello"
        '';
      };
    }
  );
}
