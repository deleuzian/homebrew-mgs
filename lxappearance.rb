require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Lxappearance < Formula
  homepage ""
  url "http://downloads.sourceforge.net/project/lxde/LXAppearance/lxappearance-0.5.5.tar.xz"
  sha1 "5497886d84bfdac0c18709e076b4acd96caba912"

  # depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "dbus-glib" => :build
  depends_on "intltool" => :build
  depends_on "libtool" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components

  depends_on "glib"
  depends_on "pango"
  depends_on "cairo"
  depends_on "perl518"
  depends_on "gtk+3"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel

    ENV.append 'LDFLAGS', "-lgthread-2.0"
    # Remove unrecognized options if warned by configure
    system "./configure", "--enable-gtk3",
                          "--enable-man",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test lxappearance`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
