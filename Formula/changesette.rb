class Changesette < Formula
  desc "A version and changelog manager for single-package applications, using the changesets file format"
  homepage "https://github.com/iorate/changesette"
  version "1.0.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.0/changesette-aarch64-apple-darwin.tar.xz"
      sha256 "d8933dc0563dbd3afd535288c5daaca2e6f1ea58d7c3afe50a03e94048e9f1b1"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.0/changesette-x86_64-apple-darwin.tar.xz"
      sha256 "1f1a8bb1a4264123c4f37a429df2b545db429faa1338366f1bb311ce8853d655"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.0/changesette-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "d54f0670ac0f76b523f46dd96dd1b1c558e9d16a2a560f0587c65ea22895705c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/changesette/releases/download/changesette-v1.0.0/changesette-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "806961ccaf17d4f69f3572a00447b6ca87d6d3ecc9496afad144ab0c6c591920"
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
