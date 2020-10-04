{
  description = "swatch beat internet time";
  
  inputs.nixpkgs.url = github:Nixos/nixpkgs/nixos-20.03;
  
  outputs = { self, nixpkgs }:
    let
      supportedSystems = [ "x86_64-linux" "i686-linux" "aarch64-linux" ];
      forAllSystems =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f system);
      version = "1.0.0";
    in {
      overlay = final: prev: {
        swatch = with final; stdenv.mkDerivation {
          name = "swatch-${version}";
          buildInputs = [ gawk utillinux ];
          src = self;
          installPhase = ''
            mkdir -p $out/bin
            cp ./swatch.sh $out/bin/swatch
            chmod +x $out/bin/swatch
          '';
          meta = {
            description = "Display the current swatch beats";
            longDescription = ''
              Prints the current Swatch Internet Time.
              Optional short form.
            '';
            homepage = https://github.com/techieAgnostic/swatch;
            maintainers = [ "Shaun Kerr - s@p7.co.nz" ];
            platforms = stdenv.lib.platforms.all;
          };
        };
      };

      defaultPackage =
        forAllSystems (system: (import nixpkgs {
          inherit system;
          overlays = [ self.overlay ];
        }).swatch);
  };
}
