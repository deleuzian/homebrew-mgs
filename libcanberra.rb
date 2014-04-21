require 'formula'

class Libcanberra < Formula
  homepage ''
  url 'http://0pointer.de/lennart/projects/libcanberra/libcanberra-0.30.tar.xz'
  sha1 'fd4c16e341ffc456d688ed3462930d17ca6f6c20'

  #patch :p0, :DATA

  depends_on 'pkg-config' => :build
  depends_on 'glib' => :build
  depends_on 'libtool' => :build
  depends_on 'gettext'
  depends_on 'intltool'
  depends_on 'libvorbis'
  depends_on 'gstreamer'
  depends_on 'gst-plugins-base'
  depends_on 'gtk+'
  depends_on 'gtk+3'

  patch :p0 do
      url "http://trac.macports.org/export/118839/trunk/dports/audio/libcanberra/files/LC_CTYPE.patch"
  end

  patch :p0 do
      url "http://trac.macports.org/export/118839/trunk/dports/audio/libcanberra/files/patch-configure.diff"
  end

  patch :p0 do
      url "http://trac.macports.org/export/118839/trunk/dports/audio/libcanberra/files/patch-gtkquartz.diff"
  end

  def install

    system "./configure", "--disable-debug",
                          #"--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--enable-gstreamer",
                          "--disable-alsa",
                          "--disable-gtk-doc",
                          "--disable-oss",
                          "--disable-lynx",
                          "--disable-null",
                          "--disable-pulse",
                          "--disable-silent-rules",
                          "--disable-tdb",
                          "--disable-udev",
                          "--enable-gtk",
                          "--enable-gtk3"

    system "make", "install"
  end

end
