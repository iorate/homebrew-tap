class Changesette < Formula
  desc "A version and changelog manager using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "7.2.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.2.2/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "8dc5d2e9efa3d97125b411c29aab9521b8c91a8b9ceb1edfb91e291551474c00"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.2.2/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "d8226b109575a285cd1f1322f611d2d0ca8a34c13cd1638d91a3e63279d5bb8e"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.2.2/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5b75fe69c0a57586741b653b6a315320f6830d18f5bc1b8bde944b3fe3f3c5d2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.2.2/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "3fc0d1be81151e77a610b6a12e1acace28e05fab4ff0e9db9b4093ad429ebe81"
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
