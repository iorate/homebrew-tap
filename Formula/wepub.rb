class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "0.4.3"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.4.3/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "8c3251c338400f85a5c4f3f0e9ac5e955155d1fd348d070a6460dfbf64f75333"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.4.3/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "f498bc75c34f23141f66704b34ede77ce0a8923470179727a1a6c18c6a17f690"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.4.3/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2d3ebc901ed2817e8cd1fb23ac8f654be25373fc43766a55d34b68ca101d76e7"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.4.3/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a6680f558148c7b771725da7571e1c251c6c1c6f829a2d7375f63f281eb7d8bb"
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
