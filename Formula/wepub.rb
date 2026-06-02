class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "0.7.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.7.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "a78de8a17a26f2c3adab283a33680db0e8a32780492967064c6e9772bcea59b3"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.7.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "cc3373219d89322d1e8bfebeaa59c4b246b04e69a3a1bf623e704f9a1ec01030"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.7.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4a575246513c365158e49d6fa88f26b24e313f77ccb515540a635e359b5d6ecf"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.7.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "77a00c35af092eb70dbe7c89686259def2b3ad01b5c2caaf7684768651cc805d"
    end
  end
  license any_of: ["MIT", "Apache-2.0"]

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "wepub" if OS.mac? && Hardware::CPU.arm?
    bin.install "wepub" if OS.mac? && Hardware::CPU.intel?
    bin.install "wepub" if OS.linux? && Hardware::CPU.arm?
    bin.install "wepub" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
