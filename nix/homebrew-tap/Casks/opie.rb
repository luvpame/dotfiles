cask "opie" do
  version "1.5.1"
  sha256 "4e13718d35b9254a4882382f871a99e9ec581ed2e12c2f63fe345c32354927fe"

  url "https://github.com/InsaneArts/opie/releases/download/v#{version}/Opie.dmg"
  name "Opie"
  desc "Radial menu"
  homepage "https://github.com/InsaneArts/opie"

  depends_on macos: :tahoe

  app "Opie.app"
end
