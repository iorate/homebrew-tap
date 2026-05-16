class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store and Firefox AMO"
  homepage "https://github.com/iorate/wepub"
  version "0.3.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.3.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "d138811f427fdf2cc37910e9dc96dee68dbd8ec34d1b6d83f4bf418745ea115f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.3.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "f1018fb0a3e9fd2c4e1930c9c9e23c361da01c9609e11b9762e1f7f220fbf147"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.3.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "4326ebc08e620906097bf5ed1b6fe324eb87d973e4056aeb274ee75043443455"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.3.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "a329a5bd3b7d55a0a72d9892a05d3e1daa5d2b48978534b101dd9ba1c6e239ce"
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
