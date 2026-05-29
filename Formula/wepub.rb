class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "0.6.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.6.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "4db8cacb3e5474f9578e2cbaf704d29a5eeff13ee02526effbf135f9fa19a621"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.6.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "2a432d054eb8355e8afa22b072853ba3b49323693bff1ba1943c6f2e20a8391f"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.6.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "2695d9a7c3b1263d9750e7e4881b3454e5450e9f4e04fd2700f6523ff6fb5afd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.6.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e289c1a1211e665c58de33d7a2e180569bd861667cccd62bd19eff80bc766ee0"
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
