class Changesette < Formula
  desc "A version and changelog manager using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "7.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.0.1/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "b96ab8e148939adf285d8cd8c859db08ea5d1bbd58b1fd4676c6a41a4df6f23a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.0.1/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "729822ad3e4d11f7d712d84daa30c6a9468e3a46328205fdc49a3d0fd66b9d60"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.0.1/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b097b7dc360698f8da8bf8981af388184ed1ad4bd421682c79fd32422f5f532"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v7.0.1/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "f5d50965c0763dd07e52402583d2ff98f8356de29dba074055bf60bc08df5d8f"
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
