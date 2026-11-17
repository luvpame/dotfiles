cask "mozkey" do
  version "1.1.0"
  sha256 "65fc763f6b1d20499030a1abef435ce87d397cee215b58e4d3d07961f3ef93cb"

  url "https://github.com/koyasi777/mozkey/releases/download/v#{version}/Mozkey_v#{version}_macos_universal.pkg"
  name "Mozkey"
  desc "Mozc-based Japanese input method with live conversion and local Zenz correction"
  homepage "https://github.com/koyasi777/mozkey"

  depends_on macos: :monterey

  pkg "Mozkey_v#{version}_macos_universal.pkg"

  uninstall pkgutil: "org.mozc.pkg.JapaneseInput"
end
