{
  config,
  inputs,
  ...
}:
let
  primaryUser = config.dotfiles.user.name;
in
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit inputs;
    };

    users.${primaryUser} = {
      imports = [
        ./packages.nix
        ./files.nix
        ./skills.nix
        ./services/agent-browser.nix
        ./services/ollama.nix
      ];

      home.stateVersion = "24.11";

      targets.darwin.currentHostDefaults."com.apple.controlcenter" = {
        # macOS Tahoe 26.7 でメニューバーにバッテリーを表示する値。
        Battery = 11;
        BatteryShowEnergyMode = 0;
        # メニューバーに天気を表示しない値。
        Weather = 8;
      };

      home.activation.linkApplications = inputs.home-manager.lib.hm.dag.entryAfter [ "linkGeneration" ] ''
        apps="$HOME/Applications"
        source="$apps/Home Manager Apps"
        lsregister=/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister

        for app in "$source"/*.app; do
          [ -e "$app" ] || continue

          link="$apps/$(basename "$app")"
          if [ ! -e "$link" ] && [ ! -L "$link" ]; then
            ln -s "$app" "$link"
            "$lsregister" -f "$link"
          fi
        done
      '';
    };
  };
}
