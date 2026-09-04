class Changesette < Formula
  desc "A version and changelog manager using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "6.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.3.0/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "60d45c1928e91e786771265c28e396017c96f8782dbb6d3178d27cacd4e97fef"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.3.0/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "af214735554b4039f44e27b0765e7707dd28cf0f32c859d7dc64b2ce5e422934"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.3.0/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "116272f620263c76249129be821acd0b762e90139cfdd9ebebc9dfc1fc4d3ddc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.3.0/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a74a166d2d0a540b3bf823d43418988bff0564b101f9f456e4c0b0d651873452"
    end
  end
  license "MIT"

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
      bin.install "changesette"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "changesette"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "changesette"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "changesette"
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
