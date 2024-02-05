class Redumper < Formula
  desc "Utility for reliably dumping optical media"
  homepage "https://github.com/superg/redumper"
  url "https://github.com/superg/redumper/archive/refs/tags/build_313.tar.gz"
  sha256 "077c769579e9f17b57ca69998cb39d11a17a01a5e214f6bb8e90122f1497def2"
  license "GPL-3.0-only"
  head "https://github.com/superg/redumper.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "llvm@17" => :build
  depends_on "ninja" => :build

  fails_with :clang do
    build 1500
    cause "Compiler does not support all C++20 features required"
  end

  fails_with :gcc do
    version "13"
    cause "Untested"
  end

  def install
    ENV["CC"]="#{HOMEBREW_PREFIX}/opt/llvm/bin/clang"
    ENV["CXX"]="#{HOMEBREW_PREFIX}/opt/llvm/bin/clang++"
    system "cmake", "-B", "BUILD", "-G", "Ninja", "-DCMAKE_BUILD_TYPE=Release", "-DREDUMPER_VERSION_BUILD=#{version}", "-DREDUMPER_CLANG_LINK_OPTIONS=-L#{HOMEBREW_PREFIX}/opt/llvm/lib/c++", "-DCMAKE_INSTALL_PREFIX=#{prefix}"
    system "cmake", "--build", "BUILD", "--config", "Release"
    bin.install "#{buildpath}/BUILD/redumper"
  end

  test do
    assert_match "build_#{version}",
                 shell_output("#{bin}/redumper --version")
  end
end
