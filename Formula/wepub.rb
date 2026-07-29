class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.2"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.2/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "b1c3776dfdbb0a36155dfd3541048851724993c2b558e6e4c48f0e53e080b79d"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.2/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "6b1c1d9f35d938a738c99deaa293feffd7488eb45359b631c8e15859cdb3b292"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.2/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "6ca56bc5e16675291620499da378816746cc0ecf5996a225517c6c8ac7496ab1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.2/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9bd4c2cc64388d5425144298688de3063d500da1a43ae940a466d1bfc1d05bdd"
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
