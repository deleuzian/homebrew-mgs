require "formula"

class FirefoxX11 < Formula
  homepage "https://developer.mozilla.org/docs/firefox"
  url "https://ftp.mozilla.org/pub/mozilla.org/firefox/releases/28.0/source/firefox-28.0.source.tar.bz2"
  head "http://hg.mozilla.org/mozilla-central", :using => :hg

  #depends_on :macos => :lion # needs clang++
  depends_on :x11
  depends_on "autoconf213" => :build
  depends_on :hg => :build
  depends_on :python => :build
  #depends_on Python273Requirement => :build
  depends_on "gettext" => :build
  depends_on "gnu-tar" => :build
  depends_on "pkg-config" => :build
  depends_on "yasm"
  depends_on "gnome-common"
  depends_on "gnome-icon-theme"
  depends_on "nspr"
  depends_on "sqlite3"
  depends_on "gconf"
  depends_on "libcanberra"
  depends_on "findutils"
  depends_on "gtk+"
  depends_on "lcms"
  depends_on "icu4c"
  depends_on "harfbuzz"
  depends_on "intltool"
  depends_on "libxml2"
  #depends_on "nss"
  depends_on "nspr"

  #patch :p1, :DATA
  
  #patch :p1 do
    #url 'file:///Users/mgs/xulrunner-x11-1.patch'
  #end
  
  #patch :p1 do
    #url 'file:///Users/mgs/xulrunner-x11-2.patch'
  #end
  
  #patch :p1 do
    #url 'file:///Users/mgs/xulrunner-x11-3.patch'
  #end
  
  #patch :p1 do
    #url 'file:///Users/mgs/xulrunner-x11-4.patch'
  #end
  
  #patch :p1 do
    #url 'file:///Users/mgs/xulrunner-x11-gfx.patch'
  #end
  
  #patch :p1 do
    #url 'file:///Users/mgs/xulrunner-x11-5.patch'
  #end
  
  #patch :p1 do
    #url 'https://trac.macports.org/export/118840/trunk/dports/devel/xulrunner-devel/files/plugin-instance-nococoa.patch'
  #end


  def install
    ENV["AUTOCONF"] = "/usr/local/bin/autoconf213"
    Dir['dom/**/*','gfx/**/*'].each do |file|
        puts.file
        inreplace file, "XP_MACOSX", "MOZ_WIDGET_COCOA"
    end
    # build xulrunner to objdir and disable tests, updater.app and crashreporter.app, specify sdk path
    (buildpath/"mozconfig").write <<-EOS.undent
      . $topsrcdir/xulrunner/config/mozconfig
      mk_add_options MOZ_OBJDIR=objdir.noindex
      ac_add_options --disable-tests
      ac_add_options --disable-ipdl-tests
      ac_add_options --disable-static
      ac_add_options --enable-shared
      ac_add_options --enable-default-toolkit=cairo-gtk2-x11
      #ac_add_options --with-macos-sdk=#{MacOS.sdk_path}
      ac_add_options --x-includes=/opt/X11/include
      ac_add_options --x-libraries=/opt/X11/lib
      ac_add_options --with-system-nspr
      ac_add_options --with-nspr-prefix=#{Formula["nspr"].opt_prefix}
      ac_add_options --with-system-bzip2=#{Formula["pbzip2"].opt_prefix}
      ac_add_options --with-system-jpeg=#{Formula["jpeg-turbo"].opt_prefix}
      ac_add_options --with-system-zlib=#{Formula["zlib"].opt_prefix}
      ac_add_options --enable-64bit
      ac_add_options --enable-system-lcms
      ac_add_options --enable-system-cairo
      ac_add_options --enable-oji
      ac_add_options --enable-plugins
      ac_add_options --enable-mathml
      ac_add_options --enable-extensions="default,spellcheck"
      ac_add_options --enable-permissions
      ac_add_options --enable-cookie
      ac_add_options --enable-image-decoders=all
      ac_add_options --enable-image-encoder=all
      ac_add_options --enable-canvas
      ac_add_options --enable-jsd
      ac_add_options --disable-xpctools
      ac_add_options --disable-webrtc
      ac_add_options --enable-crypto
      ac_add_options --enable-pango
      ac_add_options --enable-svg
      ac_add_options --enable-svg-renderer=cairo
      ac_add_options --enable-xinerama
      ac_add_options --with-pthreads
      ac_add_options --disable-gnomevfs
      ac_add_options --disable-gnomeui
      ac_add_options --disable-libnotify
      ac_add_options --enable-postscript
      ac_add_options --enable-safe-browsing
      ac_add_options --disable-crashreporter
      ac_add_options --enable-optimize='-O2'
      ac_add_options --disable-prebinding
      ac_add_options --enable-strip
      ac_add_options --enable-install-strip
      ac_add_options --disable-debug
      ac_add_options --disable-updater
      ac_add_options --disable-installer
      ac_add_options --disable-pedantic
      ac_add_options --disable-tests
      ac_add_options --disable-mochitest
      ac_add_options --disable-necko-wifi
      ac_add_options --enable-libxul

    EOS
    ## fixed usage of bsdtar with unsupported parameters (replaced with gnu-tar)
    #inreplace "toolkit/mozapps/installer/packager.mk", "$(TAR) -c --owner=0 --group=0 --numeric-owner",
              #"#{Formula["gnu-tar"].opt_bin}/gtar -c --owner=0 --group=0 --numeric-owner"

    system "make", "-f", "client.mk", "build"
    system "make", "-f", "client.mk", "package"

    system "make install"
  end
end
