require 'formula'

class Emacs < Formula
  homepage 'http://www.gnu.org/software/emacs/'
  url 'http://ftpmirror.gnu.org/emacs/emacs-24.2.tar.bz2'
  mirror 'http://ftp.gnu.org/pub/gnu/emacs/emacs-24.2.tar.bz2'
  sha1 '38e8fbc9573b70a123358b155cf55c274b5a56cf'

  option "cocoa", "Build a Cocoa version of emacs"
  option "srgb", "Enable sRGB colors in the Cocoa version of emacs"
  option "with-x", "Include X11 support"
  option "use-git-head", "Use Savannah git mirror for HEAD builds"

  if build.include? "use-git-head"
    head 'http://git.sv.gnu.org/r/emacs.git'
  else
    head 'bzr://http://bzr.savannah.gnu.org/r/emacs/trunk'
  end

#<<<<<<< Updated upstream
  #depends_on :x11 if build.include? "with-x"
  #depends_on 'jpeg'
  #depends_on 'libpng'
  #depends_on 'cairo'
  #depends_on 'libsvg-cairo'
  #depends_on 'libsvg'
  #depends_on 'librsvg'
  #depends_on 'freetype'
  #depends_on 'libotf'
  #depends_on 'giflib'
  #depends_on 'libtiff'
  #depends_on 'imagemagick'
  #depends_on 'gtk+3'
  #depends_on 'gtk+'
  #depends_on 'gtk-engines'
  #depends_on 'murrine'
#=======
  depends_on :x11
  depends_on 'pkg-config' => :build
  depends_on 'autoconf'
  depends_on 'automake'
  depends_on 'autogen'
  depends_on 'gtk+'
#>>>>>>> Stashed changes

  fails_with :llvm do
    build 2334
    cause "Duplicate symbol errors while linking."
  end

  def install
    # HEAD builds are currently blowing up when built in parallel
    # as of April 20 2012
#    ENV.j1 if build.head?

    args = ["--prefix=#{prefix}",
            "--without-dbus",
            "--build=x86_64-apple-darwin12.2.0",
            "--enable-locallisppath=#{HOMEBREW_PREFIX}/share/emacs/site-lisp",
            "--infodir=#{info}/emacs"]

    if build.head? and File.exists? "./autogen/copy_autogen"
      opoo "Using copy_autogen"
      puts "See https://github.com/mxcl/homebrew/issues/4852"
      system "autogen/copy_autogen"
    end

    if build.include? "cocoa"
      # Patch for color issues described here:
      # http://debbugs.gnu.org/cgi/bugreport.cgi?bug=8402
      if build.include? "srgb"
        inreplace "src/nsterm.m",
          "*col = [NSColor colorWithCalibratedRed: r green: g blue: b alpha: 1.0];",
          "*col = [NSColor colorWithDeviceRed: r green: g blue: b alpha: 1.0];"
      end

      args << "--with-ns" << "--disable-ns-self-contained"
      system "./configure", *args
      system "make bootstrap"
      system "make install"
      prefix.install "nextstep/Emacs.app"

      # Replace the symlink with one that avoids starting Cocoa.
      (bin/"emacs").unlink # Kill the existing symlink
      (bin/"emacs").write <<-EOS.undent
        #!/bin/bash
        #{prefix}/Emacs.app/Contents/MacOS/Emacs -nw  "$@"
      EOS
      (bin/"emacs").chmod 0755
    else
      if build.include? "with-x"
        # These libs are not specified in xft's .pc. See:
        # https://trac.macports.org/browser/trunk/dports/editors/emacs/Portfile#L74
        # https://github.com/mxcl/homebrew/issues/8156
#<<<<<<< Updated upstream
        #ENV.append 'LDFLAGS', '-lfreetype -lfontconfig'
        #args << "--with-x" << "--with-x-toolkit=gtk3" << "--with-xft=yes" << "--with-gconf=yes" << "--with-libotf=yes" << "--with-gif=no" << "--with-tiff=no" << "--with-jpeg=no" 
#=======
        ENV.append 'LDFLAGS', '-lfreetype -lfontconfig -lcairo'
        args << "--with-x" << "--x-includes=/opt/X11/include" << "--x-libraries=/opt/X11/lib" <<  "--with-x-toolkit=gtk2"
#>>>>>>> Stashed changes
      else
        args << "--without-x"
      end

      system "./configure", *args
      system "make -j"
      system "make install"
    end
  end

  def caveats
    s = ""
    if build.include? "cocoa"
      s += <<-EOS.undent
        Emacs.app was installed to:
          #{prefix}

         To link the application to a normal Mac OS X location:
           brew linkapps
         or:
           ln -s #{prefix}/Emacs.app /Applications

         A command line wrapper for the cocoa app was installed to:
          #{bin}/emacs
      EOS
    end

    s += <<-EOS.undent
      Because the official bazaar repository might be slow, we include an option for
      pulling HEAD from an unofficial Git mirror:

        brew install emacs --HEAD --use-git-head

      There is inevitably some lag between checkins made to the official Emacs bazaar
      repository and their appearance on the Savannah mirror. See
      http://git.savannah.gnu.org/cgit/emacs.git for the mirror's status. The Emacs
      devs do not provide support for the git mirror, and they might reject bug
      reports filed with git version information. Use it at your own risk.
    EOS

    return s
  end
end
