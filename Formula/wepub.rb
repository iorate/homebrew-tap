class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store and Firefox AMO"
  homepage "https://github.com/iorate/wepub"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.1.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "e12d69085e5999fac2aa5f236f739322d8fdc605f3ee23ce54e036929a4d6a31"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.1.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "c71b27fafea89a49418a1d9a22af967ced0ea6f321afc9bf94d626cb2d22f971"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.1.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "50d2751e2e7e7c800d14f7e85beaa01774db21d61e5345a7e6815ee8ab14450a"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.1.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "db37dc8d40f2fced46d8aa52686bf01901b554cbf56c9d8d1aa9c951b7fccdc3"
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
