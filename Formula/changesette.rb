class Changesette < Formula
  desc "A version and changelog manager using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "5.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v5.0.0/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "027f61640f0d45a7d12775fb5f023d6fa5f44a879b1f94f789068944f3070ddc"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v5.0.0/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "11cd103305540e8372d919f4544b859160a2dc7f0a2a632518654308fc48e543"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v5.0.0/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2021ebd3828f558e28d9599e7285e3736decead630f705fc7055790ff586eab8"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v5.0.0/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "b24570e3c88161335d4e8e07d8d7acb591571eb5d693dd05fd23e074aa820eeb"
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
