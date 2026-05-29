{ local, ... }:
let
  homebrewPrefix = "/opt/homebrew";
  brewBin = "${homebrewPrefix}/bin/brew";
  moBin = "${homebrewPrefix}/opt/mo/bin/mo";
  moleBin = "${homebrewPrefix}/opt/mole/bin/mole";
  managedSymlinks = {
    "${homebrewPrefix}/bin/mo" = moBin;
    "${homebrewPrefix}/etc/bash_completion.d/mo" = "${homebrewPrefix}/opt/mo/etc/bash_completion.d/mo";
    "${homebrewPrefix}/share/fish/vendor_completions.d/mo.fish" =
      "${homebrewPrefix}/opt/mo/share/fish/vendor_completions.d/mo.fish";
    "${homebrewPrefix}/share/zsh/site-functions/_mo" =
      "${homebrewPrefix}/opt/mo/share/zsh/site-functions/_mo";
    "${homebrewPrefix}/bin/mole" = moleBin;
  };
  managedSymlinkPaths = builtins.attrNames managedSymlinks;
  createManagedSymlinks = builtins.concatStringsSep "\n" (
    builtins.attrValues (
      builtins.mapAttrs (path: target: ''
        if [ -e ${target} ]; then
          sudo -u ${local.userName} ln -sfn ${target} ${path}
        fi
      '') managedSymlinks
    )
  );
  profileHomebrew = import (./. + "/${local.profile}.nix");

  commonBrews = [
    ### CLI Applications not available in nixpkgs
    "fisher"
    "mas" # Mac App Store CLI
    "im-select"
    "git-delta"
    "ripgrep" # codex formula dependency; keep cleanup from trying to remove it
    "curl" # cage で homebrew 産の curl が必要
    "roots"
    # `mo` と `mole` は同名バイナリを含むため、必要な link だけ activation で戻す。
    {
      name = "mo";
      link = false;
    }
    {
      name = "mole";
      link = false;
    }
  ];

  commonTaps = [
    "nikitabobko/tap" # aerospace
    "daipeihust/tap" # im-select
    "k1LoW/tap" # mo (browser markdown viewer)
    "Jean-Tinland/a-bar" # menubar
    "Warashi/tap" # cage
    "productdevbook/tap" # portkiller
  ];

  commonCasks = [
    ### GUI Applications
    "wezterm"
    "1password"
    "1password-cli"
    "aerospace"
    "figma"
    "musaicfm"
    "raycast"
    "stats"
    # "shottr"
    "scroll-reverser"
    "notchnook"
    "logitech-g-hub"
    "hhkb"
    # "cap"
    "zed"
    "deskpad"
    "logi-options+"
    "notion"
    "ankerwork"
    "codex-app"
    "codex"
    "thebrowsercompany-dia"
    "spotify"
    "azookey"
    "a-bar"
    "beekeeper-studio"
    "keycastr"
    "cage"
    "chatgpt"
    "portkiller"
    "nani"
    "wallspace"
    "macshot"

    ### Fonts
    "font-hackgen-nerd"
    "font-monaspace"
  ];

  commonMasApps = {
    "Klack" = 6446206067;
    "Grila" = 6444335028;
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
    };
    brews = commonBrews ++ profileHomebrew.brews;
    taps = commonTaps ++ profileHomebrew.taps;
    casks = commonCasks ++ profileHomebrew.casks;
    masApps = commonMasApps // profileHomebrew.masApps;
  };

  # `mo` と `mole` は同名バイナリを含むため、brew 管理の link を外して衝突を避ける。
  system.activationScripts.preActivation.text = ''
    if [ -x ${brewBin} ]; then
      ${brewBin} unlink mo >/dev/null 2>&1 || true
      ${brewBin} unlink mole >/dev/null 2>&1 || true
    fi

    for path in ${toString managedSymlinkPaths}; do
      if [ -L "$path" ]; then
        rm -f "$path"
      fi
    done
  '';

  # brew 管理の link を避けた上で、必要なコマンドと補完だけ /opt/homebrew 配下に戻す。
  # activation は root 実行だが /opt/homebrew/bin の owner に揃えるため sudo -u でユーザー権限に降りる。
  system.activationScripts.postActivation.text = ''
    ${createManagedSymlinks}
  '';
}
