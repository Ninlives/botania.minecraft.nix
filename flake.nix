{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable-small";

  inputs.mc-config = {
    url = "github:linyinfeng/mc-config";
    inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { mc-config, nixpkgs, ... }:
    let
      sys = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${sys};
    in {
      packages.${sys} = {
        client = (mc-config.lib.mkLaunchers pkgs {
          launcherConfig = nixpkgs.lib.importJSON ./config.json;
        }).client-launcher.withConfig {
          shaderPacks = [
            (builtins.fetchurl {
              url =
                "https://media.forgecdn.net/files/3752/138/BSL_v8.1.02.2.zip";
              sha256 =
                "sha256:0aap1hd7a0alzviwg56138smhzj677n4zp7gks996adsbha0k7y4";
            })
          ];
        };
        inherit (mc-config.packages.${sys}) update;
      };
    };
}
