{ config, lib, ... }:
let
  primaryUser = config.dotfiles.user.name;
in
{
  options.dotfiles.user.name = lib.mkOption {
    type = lib.types.nonEmptyStr;
    description = "The primary macOS user name.";
  };

  config = {
    dotfiles.user.name = "luvpame";
    system.primaryUser = primaryUser;
    users.users.${primaryUser}.home = "/Users/${primaryUser}";
  };
}
