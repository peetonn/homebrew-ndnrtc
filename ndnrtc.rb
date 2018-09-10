# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
class Ndnrtc < Formula
    desc "NDN-RTC Conferencing Library"
    homepage "https://github.com/remap/ndnrtc"
    url "https://github.com/remap/ndnrtc/archive/v3.0.2.tar.gz"
    sha256 "4ddcde5ff293234c0a0fb7905ee60814b1d8d6b40f7272ff134285402325f350"
    
    depends_on "cmake" => :build
    depends_on "boost@1.60"
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "openssl"
    depends_on "libconfig"
    depends_on "rocksdb"
    depends_on "nanomsg"
    depends_on "sqlite3"
  
    resource "openfec" do
      url "http://131.179.142.102:8000/openfec-1.4.2-macos.tar.gz"
      sha256 "3c419d65e4a778b3537b87d3d1d31238045e06fff008438eccb1cfd4fdb10812"
    end
  
    resource "ndn-cpp" do
      url "http://131.179.142.102:8000/ndn-cpp-v0.14-macos.tar.gz"
      sha256 "a651ac761563e709e2e4c2ab6b030a579fee55fdbdd101f0febe616843f12c3a"
    end
  
    resource "webrtc" do
      url "http://131.179.142.102:8000/webrtc-branch59-macOS.tar.gz"
      sha256 "1d78ec29333725c8897e6d5d8f6ef0ddfdbbc0d7d27e7ed917b0144e18e72042"
    end
  
    def install
      resource("openfec").stage do |stage|  
          @openfecPath = Dir.pwd
          stage.staging.retain!
      end
      resource("ndn-cpp").stage do |stage| 
          @ndncppPath = Dir.pwd
          stage.staging.retain!
      end
      resource("webrtc").stage do |stage|
          @webrtcPath = Dir.pwd
          stage.staging.retain!
      end
  
      # ENV.deparallelize  # if your formula fails when building in parallel
      # Remove unrecognized options if warned by configure
      Dir.chdir("cpp")
      ENV['WEBRTCDIR'] = @webrtcPath
      ENV['OPENFECDIR'] = @openfecPath
      ENV['NDNCPPDIR'] = "#{@ndncppPath}/include"
      ENV['NDNCPPLIB'] = "#{@ndncppPath}/lib"
      ENV['CPPFLAGS'] = "-g -O2 -DWEBRTC_POSIX -I/usr/local/opt/boost@1.60/include"
      ENV['CXXFLAGS'] = "-g -O2 -DWEBRTC_POSIX"
      # all these libs and frameworks are needed because we link against static ndn-cpp
      ENV['LDFLAGS'] = "-L/usr/local/opt/boost@1.60/lib -lsqlite3 -framework Security -framework System -framework Cocoa -framework AVFoundation"

      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
      system "make", "ndnrtc-client"
      bin.install 'ndnrtc-client'
    end
  
    test do
      # `test do` will create, run in and delete a temporary directory.
      #
      # This test will fail and we won't accept that! For Homebrew/homebrew-core
      # this will need to be a test that verifies the functionality of the
      # software. Run the test with `brew test ndnrtc`. Options passed
      # to `brew install` such as `--HEAD` also need to be provided to `brew test`.
      #
      # The installed folder is not in the path, so use the entire path to any
      # executables being tested: `system "#{bin}/program", "do", "something"`.
      system "true"
    end
  end
  