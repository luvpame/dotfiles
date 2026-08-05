{
  inputs,
  local,
  ...
}:
{
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    backupFileExtension = "backup";
    extraSpecialArgs = {
      inherit
        local
        inputs
        ;
    };

    users.${local.userName} =
      { ... }:
      {
        imports = [
          ./packages/common.nix
          ./files/common.nix
          ./services/herdr.nix
          (./files + "/${local.profile}.nix")
        ];

        home.stateVersion = "24.11";
        home.username = local.userName;
        home.homeDirectory = local.homeDirectory;

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
