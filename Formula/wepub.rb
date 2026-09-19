class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.5"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.5/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "8b024eae26b485de93e108bac67bc4144995431a5bbb232c35a1599075fa4f17"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.5/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "7b41640dd4c3c13bd6332f295124865c42ada967bc5608af27b0ab3156679288"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.5/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "5d5ab580ba1dd6c5b121bdc2381d446adc7377c4988a587c67b081aaecb2b697"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.5/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "9ce18c7a3243695fa78b4e0f76322289584581b498af3ff5f54e76c2fdba2555"
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
