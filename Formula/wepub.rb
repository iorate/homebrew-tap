class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.4"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.4/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "cfdf435280c0467ad40fd538393aa5c1d2ec50b9f5412e4abdb312f5998c0e8e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.4/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "aa2883f490c7b0e592b8fad92c2fd5f9eb2eb7dca0e8df6136dbc313ac628e16"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.4/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1e8baf954ccd27b2a44eb8236f68ad9d1f613681fa4b1e93cd99d088089dbc92"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.4/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "309507fc19370dc27e4e9d626a11d3545ccc71295955bb6e0048eb8c12765993"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "wepub"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "wepub"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "wepub"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "wepub"
    end

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
