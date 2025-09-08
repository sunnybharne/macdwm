class Macdwm < Formula
  desc "A minimal macOS tiling window manager inspired by dwm"
  homepage "https://github.com/sunnybharne/macdwm"
  url "https://github.com/sunnybharne/macdwm/archive/v1.0.0.tar.gz"
  sha256 "PLACEHOLDER_SHA256"
  license "MIT"
  head "https://github.com/sunnybharne/macdwm.git", branch: "main"

  depends_on :macos
  depends_on "swift" => :build

  def install
    system "swift", "build", "--configuration", "release", "--disable-sandbox"
    bin.install ".build/release/macdwm"
  end

  test do
    # Test that the binary exists and is executable
    assert_predicate bin/"macdwm", :exist?
    assert_predicate bin/"macdwm", :executable?
  end

  def caveats
    <<~EOS
      macdwm requires Accessibility permissions to function properly.
      
      To grant permissions:
      1. Open System Settings → Privacy & Security → Accessibility
      2. Click the + button and add your terminal application
      3. Ensure the toggle is enabled
      
      Then run: macdwm
    EOS
  end
end
