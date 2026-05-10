class Wepub < Formula
  desc "CLI to publish browser extensions to Chrome Web Store and Firefox AMO"
  homepage "https://github.com/iorate/wepub"
  version "0.2.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.2.0/wepub-aarch64-apple-darwin.tar.xz"
      sha256 "3750e11cf3d13f084e8459cc0cedd125e56d27889c08fd977eb06bb96243a719"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.2.0/wepub-x86_64-apple-darwin.tar.xz"
      sha256 "901cabfad922ce42369b7f969e9f39572689ea815c256b1acf1215128967b734"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/iorate/wepub/releases/download/v0.2.0/wepub-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "1ff958dea60f020236790cc329ef03df5dfddf8378123f5466848d78e533b6ce"
    end
    if Hardware::CPU.intel?
      url "https://github.com/iorate/wepub/releases/download/v0.2.0/wepub-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "53f23fb3ecd716b424c747e93427328de9960599fb9e387837602865698efc51"
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
