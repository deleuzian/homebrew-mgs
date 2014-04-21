require "formula"

# Documentation: https://github.com/Homebrew/homebrew/wiki/Formula-Cookbook
#                /usr/local/Library/Contributions/example-formula.rb
# PLEASE REMOVE ALL GENERATED COMMENTS BEFORE SUBMITTING YOUR PULL REQUEST!

class Xscreensaver < Formula
  homepage ""
  url "http://www.jwz.org/xscreensaver/xscreensaver-5.26.tar.gz"
  sha1 "8055822b661733e68550872a4ae6b6129c0b73fc"

  # depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on :x11 # if your formula requires any X11/XQuartz components
  depends_on "gettext"
  depends_on "glade"
  depends_on "intltool"
  depends_on "libtool"
  depends_on "libjpeg-turbo"
  depends_on "gtk+"
  depends_on "gdk-pixbuf"

  def install
    # ENV.deparallelize  # if your formula fails when building in parallel
    ENV['GL_LIBS'] = "/opt/X11/lib/X11/GL"
    ENV.append "LDFLAGS", "-lintl"

    # Remove unrecognized options if warned by configure
    system "./configure", "--prefix=#{prefix}",
                          "--with-gl",
                          "--with-pixbuf",
                          "--with-x-app-defaults=/opt/X11/share/X11/app-defaults",
                          "--with-jpeg",
                          "--with-gtk",
                          #"--with-xshm-ext",
                          "--x-includes=/opt/X11/include",
                          "--x-libraries=/opt/X11/lib",
                          "--prefix=/usr/local/Cellar/xscreensaver/5.26"
    # system "cmake", ".", *std_cmake_args
    system "make"
    system "make install" # if this fails, try separate make/make install steps
  end

  test do
    # `test do` will create, run in and delete a temporary directory.
    #
    # This test will fail and we won't accept that! It's enough to just replace
    # "false" with the main program this formula installs, but it'd be nice if you
    # were more thorough. Run the test with `brew test xscreensaver`.
    #
    # The installed folder is not in the path, so use the entire path to any
    # executables being tested: `system "#{bin}/program", "do", "something"`.
    system "false"
  end
end
