cask "rex-beta" do
  version :latest
  sha256 :no_check

  url "https://blob.superlogical.com/download/rex-app/preview/latest.dmg"
  name "Rex Beta"
  desc "Multiplexer for terminals and applications"
  homepage "https://www.superlogical.com/rex/"

  auto_updates true
  depends_on macos: :sequoia

  app "Rex Beta.app"
  binary "#{appdir}/Rex Beta.app/Contents/Helpers/Rex Server.rex/Contents/MacOS/rex"
end
