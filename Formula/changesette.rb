class Changesette < Formula
  desc "A version and changelog manager for single-package applications, using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "2.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v2.0.1/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "2f77f2208a09c6fb4bcd034422dadb9a0f6d53e086983b2b14746c671a1af392"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v2.0.1/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "8e753ba60b2f4a06fa09f95a2c4bc4fbe614225585e45a53d98650f87334cd39"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v2.0.1/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "45eaf3951d8b0f972e9d9fad6e44a5dd08c6a5c7be98b13f5890540a2d2b437e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v2.0.1/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8493a4fcc07e513219b44c36caa6888f5a73fbaa41f94acaceb9bdcd56c332d9"
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
    bin.install "changesette" if OS.mac? && Hardware::CPU.arm?
    bin.install "changesette" if OS.mac? && Hardware::CPU.intel?
    bin.install "changesette" if OS.linux? && Hardware::CPU.arm?
    bin.install "changesette" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
