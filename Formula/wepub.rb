class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store, Firefox Add-ons, and Edge Add-ons"
  homepage "https://github.com/iorate/wepub"
  version "1.0.7"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.7/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "52fd5478ae73e426b027dc94f52022534dc5ecba098bb57c47411a93d119a5fd"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.7/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "3c7bba01958c54a15f0b7054723c79953c0d28291e7e9bdc2ec9d571a0c19f01"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.7/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "ed018d63a52de6aaf08adb69cdb2e5d77dadba88cdfcfa6e67644272478ee15e"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/wepub-v1.0.7/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "e37a40ca981cc7edfbf13e0952974bd2817c40b025dcb483aa382264175f3f00"
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
