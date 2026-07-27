class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.1"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v1.0.1/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "461c6b8ee928d238cca5ab3f18d3b5e663d00c9dcd6e4329a3ca672d036296a4"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v1.0.1/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "d56ca051c15bbf53f17ab02ea52951bdc06a1cbb4f6a8a99b5a90ac72a261498"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v1.0.1/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "9b49f0f97d39b1434a4622128ae6074f225977e908c4fb034879a3bb69db198c"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v1.0.1/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "13428be37e6f3184d1017213d9c11936a1d3399019193ffd18ad0b3119fbd0f3"
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
