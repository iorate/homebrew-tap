class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v1.0.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "8d08dce5f92e07a6f6d2168f3d2c43185a1e50987318031ccf308340e3d79354"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v1.0.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "cc591f58877c37ea5d7779e777dd49e524d6ac9ec3769e4e08beb00b073baf29"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v1.0.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d7e638c5865fe3cadc809b840caf63249e5c69754d0c2086048a2d2fa924d000"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v1.0.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "873ec244bd9e93e09261b8fe74995476d2c3df91d3f1e1543fc45b1aa859fdb4"
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
