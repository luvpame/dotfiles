{ config, ... }:
let
  primaryUser = config.dotfiles.user.name;
  homebrewPrefix = "/opt/homebrew";
  localTapSource = builtins.path {
    path = ../homebrew-tap;
    name = "dotfiles-homebrew-tap";
  };
  localTapPath = "${homebrewPrefix}/Library/Taps/luvpame/homebrew-dotfiles-local";

  brewPackages = [
    ### CLI Applications not available in nixpkgs
    "fisher"
    "mas" # Mac App Store CLI
    "worktrunk"
    "ripgrep" # codex formula dependency; keep cleanup from trying to remove it
    "mole"
  ];

  tapNames = [
    "abue-ammar/tinycast"
    "ardia-browser/tap"
    "nikitabobko/tap" # aerospace
    "gauthierpiarrette/highball"
    "luvpame/dotfiles-local"
  ];
  trustedTaps = map (name: {
    inherit name;
    trusted = true;
  }) tapNames;

  caskNames = [
    ### GUI Applications
    "altserver"
    "discord"
    "rekordbox"
    "wezterm"
    "1password"
    "1password-cli"
    "aerospace"
    "thaw"
    "tinycast"
    "scroll-reverser"
    "notchnook"
    "logitech-g-hub"
    "hhkb"
    "zed"
    "visual-studio-code"
    "logi-options+"
    "ankerwork"
    "muse-code"
    "crisp"
    "ardia-browser/tap/ardia"
    "spotify"
    "steam"
    "highball"
    "keycastr"
    "nani"
    "wallspace"
    "cap"
    "capsomnia"
    "shottr"
    "luvpame/dotfiles-local/rex-beta"
    "luvpame/dotfiles-local/mozkey"

    ### Fonts
    "font-plemol-jp-nf"
    "font-monaspace"
  ];

  masApplications = {
    "Xcode" = 497799835;
    "Klack" = 6446206067;
    "RunCat Neo" = 6757801838;
  };
in
{
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation = {
      upgrade = true;
      autoUpdate = true;
      cleanup = "zap";
      extraFlags = [ "--force-cleanup" ];
    };
    brews = brewPackages;
    taps = trustedTaps;
    casks = caskNames;
    masApps = masApplications;
  };

  system.activationScripts.preActivation.text = ''
    if [ -L "${localTapPath}" ]; then
      if ! [[ "$(readlink "${localTapPath}")" =~ ^/nix/store/[0-9a-z]{32}-dotfiles-homebrew-tap$ ]]; then
        printf '%s\n' "Refusing to replace an unmanaged tap symlink: ${localTapPath}" >&2
        exit 1
      fi
    elif [ -e "${localTapPath}" ]; then
      printf '%s\n' "Refusing to replace an existing tap: ${localTapPath}" >&2
      exit 1
    fi
    sudo -u ${primaryUser} mkdir -p "${homebrewPrefix}/Library/Taps/luvpame"
    sudo -u ${primaryUser} ln -sfn "${localTapSource}" "${localTapPath}"
  '';
}
