# Documentation: https://docs.brew.sh/Formula-Cookbook
#                http://www.rubydoc.info/github/Homebrew/brew/master/Formula
class Ndnrtc < Formula
    desc "NDN-RTC Conferencing Library"
    homepage "https://github.com/remap/ndnrtc"
    url "https://github.com/remap/ndnrtc/archive/v3.0.2.tar.gz"
    sha256 "f10e68f39e4d48793bd014651488aa30479cdc344a45518f055f4e41cdc61ff2"
    
    depends_on "cmake" => :build
    depends_on "boost"
    depends_on "automake" => :build
    depends_on "libtool" => :build
    depends_on "openssl"
    depends_on "libconfig"
    depends_on "rocksdb"
    depends_on "nanomsg"
    depends_on "sqlite3"
  
    resource "openfec" do
      url "http://131.179.142.102:8000/openfec-active-macos.tar.gz"
      sha256 "238db7a08f30cc1ee6a17418f625894bd4bb8adcdda6e3657e9acb3190ddc02a"
    end
  
    resource "ndn-cpp" do
      url "http://131.179.142.102:8000/ndn-cpp-active-macos.tar.gz"
      sha256 "2b66fa2e4bc96c79081576d2c64ad474fb90728e59bf69820f5c724b44932697"
    end
  
    resource "webrtc" do
      url "http://131.179.142.102:8000/webrtc-active-macOS.tar.gz"
      sha256 "9f6116cb1fe7542460314ec8c8b93fa7424f53da26acaaf5dbac062275710c8d"
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
      ENV['CPPFLAGS'] = "-g -O2 -DWEBRTC_POSIX" # -I/usr/local/opt/boost@1.60/include"
      ENV['CXXFLAGS'] = "-g -O2 -DWEBRTC_POSIX"
      # all these libs and frameworks are needed because we link against static ndn-cpp
      ENV['LDFLAGS'] = "-lsqlite3 -framework Security -framework System -framework Cocoa -framework AVFoundation #{@ndncppPath}/lib/libndn-cpp.a"

      system "./configure", "--prefix=#{prefix}"
      system "make", "install"
      system "make", "ndnrtc-client"
      bin.install 'ndnrtc-client'
      bin.install '.libs/ndnrtc-client'
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
  