{ userName, homeDirectory, ... }:
{
  users.users.${userName} = {
    name = userName;
    home = homeDirectory;
  };
}
