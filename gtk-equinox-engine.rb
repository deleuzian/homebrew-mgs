require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class GtkEquinoxEngine < Formula
  homepage ""
  url "http://gnome-look.org/CONTENT/content-files/121881-equinox-1.50.tar.gz"
  sha1 "12747e4bcc2226c3142ff52800505d188c2abb00"

  # depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "gtk+"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    # Remove unrecognized options if warned by configure
    system "./configure", "--prefix=#{prefix}", "--enable-animation"
    # system "cmake", ".", *std_cmake_args
    system "make", "install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test 121881-equinox`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
