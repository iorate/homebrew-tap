class Changesette < Formula
  desc "A version and changelog manager for single-package applications, using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.0/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "9c504a0fc00b811ce927ecadcc3af7ae017f99cdbc2821cf15b3aa346d343a68"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.0/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "bff25ec927ae3749dd34d668219d20db821e7a4b88cbdb62abe1e251b851d30c"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.0/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "084450c40dece5137d5611ecbb0d52e54cbea1f8f900f0ca5ac44af8ed6f750a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v0.1.0/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "cd85e22881f4cbc01274939a2db3db55dc4ae85a23c54382a030a1a7103f2c2a"
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
