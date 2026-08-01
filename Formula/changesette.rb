class Changesette < Formula
  desc "A version and changelog manager for single-package applications, using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "0.1.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.1/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "548197d8e9f510bcf150e3df177d6ce58fa7b0009301483abc2e0bc18e09abde"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.1/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "a6f08dc948a21391098f18749bc8857548eaa95f2bba51fa3ad03295476a6585"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.1/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "13636c7a1bc185b7d4e63f1a53d570c10f45cebdf27aab022f618ce3c588f98b"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.1/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "103fa03ade9d553c9edff36cdecc9d38ca8737ad14cbc8618a943f2721bfa574"
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
