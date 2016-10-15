{ config, lib, pkgs, ... }:

let
  cfg = config.humblebundle;

  self = rec {
    callPackage = pkgs.lib.callPackageWith (pkgs // self);
    callPackage_i686 = pkgs.lib.callPackageWith (pkgs.pkgsi686Linux // self);

    fetchHumbleBundle = callPackage ./fetch-humble-bundle {
      inherit (config.humblebundle) email password;
    };

    humbleApi  = callPackage ./humbleApi { requests2 = pkgs.pythonPackages.requests2; };
    
    bastion = callPackage ./bastion.nix {};
    brigador = callPackage ./brigador.nix {};
    cavestoryplus = callPackage ./cavestoryplus.nix {};
    curious-expedition = callPackage ./curious-expedition.nix {};
    fez = callPackage ./fez.nix {};
    ftl = callPackage ./ftl.nix {};
    guacamelee = callPackage_i686 ./guacamelee.nix {};
    hammerwatch = callPackage ./hammerwatch.nix {};
    jamestown = callPackage ./jamestown.nix {};
    liads = callPackage ./liads.nix {};
    megabytepunch = callPackage ./megabytepunch.nix {};
    pico-8 = callPackage ./pico-8.nix {};
    rocketbirds = callPackage ./rocketbirds.nix {};
    spaz = callPackage ./spaz.nix {};
    starbound = callPackage ./starbound.nix {};
    swordsandsoldiers = callPackage ./swordsandsoldiers.nix {};
    unepic = callPackage ./unepic.nix {};
  };
in with lib; {
  options.humblebundle = {
    email = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Email address for your HumbleBundle account.
      '';
    };

    password = mkOption {
      type = types.nullOr types.str;
      default = null;
      description = ''
        Password for your HumbleBundle account.
      '';
    };
  };

  config.packages = {
    humblebundle = mkIf (cfg.email != null && cfg.password != null) self;
  };
}
