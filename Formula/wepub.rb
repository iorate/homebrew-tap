class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.6"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.6/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "4a652bc9e016a7bf476bbbdda68f5762acf08c6d36e18b1e2f71e533d6748da2"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.6/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "5e2111157c6bf9a00ec576366b802cca2bdf4e5cde0c09a1e0c516a751690365"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.6/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "fb400bc5dea5f87b110610fcca78c168ded14b3dd80728f53146a6aea955e763"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.6/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "c111afab71f573616367942bd0b35e5cc04138af83f21dc31b4f94369915f3a5"
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
    if OS.mac? && Hardware::CPU.arm?
      bin.install "wepub"
    end
    if OS.mac? && Hardware::CPU.intel?
      bin.install "wepub"
    end
    if OS.linux? && Hardware::CPU.arm?
      bin.install "wepub"
    end
    if OS.linux? && Hardware::CPU.intel?
      bin.install "wepub"
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
