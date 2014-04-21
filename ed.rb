require 'formula'

class Ed < Formula
  homepage 'http://www.gnu.org/software/ed/ed.html'
  url 'http://ftpmirror.gnu.org/ed/ed-1.9.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/ed/ed-1.9.tar.gz'
  sha1 'a7f01929eb9ae5fe2d3255cd99e41a2211571984'

  def install
    args = ["--prefix=#{prefix}"]
    ENV.j1
    system "./configure", *args
    system "make"
    system "make install"
  end
end
