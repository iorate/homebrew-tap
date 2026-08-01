class Changesette < Formula
  desc "A version and changelog manager for single-package applications, using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.1/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "9acda9271ec1496ebe4859bd48489593c32c6c81b0dedb307c30bf3a139b8a77"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.1/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "7ae8579a69b598c2fbcd08ed92d02f71a45f0e01b896d5139ea0319affa880e7"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.1/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "a85fac0ce7fd9b06cf10a294132d0ff03031b765e6127734d458e7d81dbe6c35"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.1/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "4f3cba49b7b88b3176db45a8910688c1d7f3898c5263142a4adf6de58115c0cc"
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
