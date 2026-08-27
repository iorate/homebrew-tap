class Changesette < Formula
  desc "A version and changelog manager using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "6.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.2.0/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "b4aaf6baefdd884d5676c0ec7562ab358a08fd33854b470f88a11fa2f9d05546"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.2.0/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "002d8a00197304e1347900f12ab349ae8b64df872a5d064c16668f2309bbc955"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.2.0/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "f8f70a22ad4434fc0c36a1203ace1f3d22ca7abb8033b213396e2e4f4f92e7a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v6.2.0/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "8ce6cc0d69603f9db9b3d2f8f70b3bab349430dbecc46a16419659f3518bb8c4"
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
