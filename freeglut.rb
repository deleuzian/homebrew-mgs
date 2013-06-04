require 'formula'

class Freeglut < Formula
  homepage ''
  url 'http://downloads.sourceforge.net/project/freeglut/freeglut/2.8.0/freeglut-2.8.0.tar.gz'
  version '2.8.0'
  sha1 '4debbe559c6c9841ce1abaddc9d461d17c6083b1'

  # depends_on 'cmake' => :build
  depends_on :x11
  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'glib'
  depends_on 'libtool'


  def install
    system "autoreconf -fvi"

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-x",
                          "--x-includes=/opt/X11/include",
                          "--x-libraries=/opt/X11/lib"

    system "make install"
  end
end
