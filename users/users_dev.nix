{ config, pkgs, lib, ... }:

{
  users.extraUsers.dev = {
    isNormalUser = true;
    extraGroups = [ "vboxusers" "wheel" "mpd" "networkmanager"];
    uid = 1000;
    shell = "${pkgs.zsh}/bin/zsh";
  };
}
