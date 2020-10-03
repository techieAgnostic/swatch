{
  description = "swatch beat internet time";
  inputs.nixpkgs.url = github:Nixos/nixpkgs/nixos-20.03;
  outputs = { self, nixpkgs }: {
    overlay = final: prev: with nixpkgs; {
      swatch = swatch;
    };
    defaultPackage.x86_64-linux =
      with import nixpkgs { system = "x86_64-linux"; };
      stdenv.mkDerivation rec {
        name = "swatch-${version}";
        version = "1.0.0";
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
        src = self;
        buildInputs = [
          gawk
          utillinux
        ];
        buildPhase = "cp ./swatch.sh ./swatch";
        installPhase = "mkdir -p $out/bin; install -t $out/bin swatch";
      };
  };
}
