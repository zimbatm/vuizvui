{ pkgs, lib, myLib }:

with pkgs;
let

  addPythonRuntimeDeps = drv: deps: drv.overrideDerivation (old: {
    propagatedNativeBuildInputs = old.propagatedNativeBuildInputs ++ deps;
  });

  # containered = name: packages: users: { ... }:
  #   {
  #     containers."${name}" = {
  #       config = {
  #         environment.systemPackages = packages;
  #         users.users = users;
  #         services.sshd.enable = true;
  #       };
  #       privateNetwork = true;
  #       localAddress = "127.0.0.2";
  #     };
  #     nixpkgs.config.allowUnfree = true;
  #   };

  # pkgs

  offlineimap = addPythonRuntimeDeps pkgs.offlineimap [ pkgs.pythonPackages.pygpgme ];

  taffybar = pkgs.taffybar.override {
    ghcWithPackages = (pkgs.haskellPackages.override {
      overrides = _: super: {
        taffybar = super.taffybar.overrideDerivation (old: {
          name = old.name + "foo";
          patches = (old.patches or []) ++ [ ./patches/taffybar.patch ];
          postPatch = old.postPathPhase or "" + ''
            patch -R ${./patches/taffybar-color.patch}
          '';
        });
      };
    }).ghcWithPackages;
  };

  sent = pkgs.sent.override { patches = [ ./patches/sent-bg.patch ]; };

  mpv = pkgs.mpv.override { scripts = [ pkgs.mpvScripts.convert ]; };

  beets = pkgs.beets.override { enableAlternatives = true; };

  # git-annex = hplts.git-annex.overrideDerivation (old: {
  #     buildInputs = old.buildInputs ++ [ pkgs.makeWrapper ];
  #     postFixup = ''
  #       wrapProgram $out/bin/git-annex --prefix PATH ":" "${getBin pkgs.lsof}/bin";
  #     '';
  # });

  poezio = pkgs.python34Packages.poezio;

  vim = vim_configurable;

  fast-init = pkgs.haskellPackages.callPackage (import "${(pkgs.fetchFromGitHub {
    owner = "Profpatsch";
    repo = "fast-init";
    # TODO fix version
    rev = "master";
    sha256 = "03006xzs250knzcyr6j564kn9jf2a6cp3mxkpqsqmmyp6v28w90z";
  })}/overrides.nix") {};

  youtube-dl = pkgs.youtube-dl.overrideDerivation (old: {
    patches = old.patches or [] ++ [ ./patches/youtube-dl.patch ];
  });

  xmpp-client = pkgs.callPackage (import ./xmpp-client.nix myLib.philip.home "irc/xmppOla.wtf") { inherit (pkgs) xmpp-client; };

in
{ inherit taffybar offlineimap sent mpv beets poezio vim fast-init youtube-dl xmpp-client; }
