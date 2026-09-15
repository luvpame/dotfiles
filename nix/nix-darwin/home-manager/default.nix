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
        ./services/herdr.nix
      ];

      home.stateVersion = "24.11";

      # macOS Tahoe の設定画面で非表示時の値を確認済み。
      targets.darwin.currentHostDefaults."com.apple.controlcenter" = {
        Battery = 9;
        BatteryShowEnergyMode = 0;
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
