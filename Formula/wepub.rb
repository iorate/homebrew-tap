class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "0.9.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.9.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "8a02fb3ec13ce38f240782ba5ed0633dcf565dc5c5e449f309ae493456f0b0fb"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.9.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "fc33774b45bca84ead62516dae098f9e3a6cdd411580aa8b332ebf01dcd2af7e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.9.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "3178767516c75c64ca531ddf6b88cd7a22f2f0ea292072d06665a6e7d5c16746"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.9.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "d27136f3fec6198e72d43eeea286ae7b8faacb9a6192d2c296269316241b3eb7"
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
