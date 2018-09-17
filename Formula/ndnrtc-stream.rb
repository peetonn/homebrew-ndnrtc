class NdnrtcStream < Formula
  include Language::Python::Virtualenv

  desc "A python wrapper for ndnrtc-client for quick&easy NDN video streaming"
  homepage "https://github.com/remap/ndnrtc-stream"
  url "https://github.com/remap/ndnrtc-stream/archive/v0.0.1.tar.gz"
  sha256 "9c3c544bfb95762a7d04ce048f206d4d8b3c9a6d7bc5c6a12b2e0888d766fdaf"

  depends_on "ffmpeg" => ['--with-sdl2', '--with-fontconfig', '--with-freetype']
  depends_on "python@2"

  resource "docopt" do
    url "https://files.pythonhosted.org/packages/a2/55/8f8cab2afd404cf578136ef2cc5dfb50baa1761b68c9da1fb1e4eed343c9/docopt-0.6.2.tar.gz"
    sha256 "49b3a825280bd66b3aa83585ef59c4a8c82f2c8a522dbe754a8bc8d08c85c491"
  end

  resource "libconf" do
    url "https://files.pythonhosted.org/packages/7c/70/e7780ef82bf2ee05a74f192083209139cd5a75404c6d5ff5c26ef1f20a93/libconf-1.0.1.tar.gz"
    sha256 "6dd62847bb69ab5a09155cb8be2328cce01e7ef88a35e7c37bea2b1a70f8bd58"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    true
  end
end
