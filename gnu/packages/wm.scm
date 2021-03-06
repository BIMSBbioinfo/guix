;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2015 Eric Dvorsak <eric@dvorsak.fr>
;;; Copyright © 2015 Siniša Biđin <sinisa@bidin.eu>
;;; Copyright © 2015, 2016 Eric Bavier <bavier@member.fsf.org>
;;; Copyright © 2015 xd1le <elisp.vim@gmail.com>
;;; Copyright © 2015 Paul van der Walt <paul@denknerd.org>
;;; Copyright © 2016 Danny Milosavljevic <dannym@scratchpost.org>
;;; Copyright © 2016 Efraim Flashner <efraim@flashner.co.il>
;;; Copyright © 2016 Al McElrath <hello@yrns.org>
;;; Copyright © 2016 Carlo Zancanaro <carlo@zancanaro.id.au>
;;; Copyright © 2016, 2017 Ludovic Courtès <ludo@gnu.org>
;;; Copyright © 2016, 2017, 2018 ng0 <ng0@crash.cx>
;;; Copyright © 2016 doncatnip <gnopap@gmail.com>
;;; Copyright © 2016 Ivan Vilata i Balaguer <ivan@selidor.net>
;;; Copyright © 2017 Mekeor Melire <mekeor.melire@gmail.com>
;;; Copyright © 2017 Marius Bakke <mbakke@fastmail.com>
;;; Copyright © 2017 Oleg Pykhalov <go.wigust@gmail.com>
;;; Copyright © 2018 Tobias Geerinckx-Rice <me@tobias.gr>
;;;
;;; This file is part of GNU Guix.
;;;
;;; GNU Guix is free software; you can redistribute it and/or modify it
;;; under the terms of the GNU General Public License as published by
;;; the Free Software Foundation; either version 3 of the License, or (at
;;; your option) any later version.
;;;
;;; GNU Guix is distributed in the hope that it will be useful, but
;;; WITHOUT ANY WARRANTY; without even the implied warranty of
;;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;;; GNU General Public License for more details.
;;;
;;; You should have received a copy of the GNU General Public License
;;; along with GNU Guix.  If not, see <http://www.gnu.org/licenses/>.

(define-module (gnu packages wm)
  #:use-module ((guix licenses) #:prefix license:)
  #:use-module (guix packages)
  #:use-module (gnu packages)
  #:use-module (gnu packages linux)
  #:use-module (guix build-system cmake)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system haskell)
  #:use-module (guix build-system perl)
  #:use-module (guix build-system python)
  #:use-module (gnu packages haskell)
  #:use-module (gnu packages haskell-check)
  #:use-module (gnu packages haskell-web)
  #:use-module (gnu packages autotools)
  #:use-module (gnu packages bison)
  #:use-module (gnu packages gawk)
  #:use-module (gnu packages base)
  #:use-module (gnu packages pkg-config)
  #:use-module (gnu packages perl)
  #:use-module (gnu packages pulseaudio)
  #:use-module (gnu packages xorg)
  #:use-module (gnu packages xdisorg)
  #:use-module (gnu packages documentation)
  #:use-module (gnu packages xml)
  #:use-module (gnu packages m4)
  #:use-module (gnu packages docbook)
  #:use-module (gnu packages image)
  #:use-module (gnu packages pcre)
  #:use-module (gnu packages python)
  #:use-module (gnu packages gtk)
  #:use-module (gnu packages libevent)
  #:use-module (gnu packages fribidi)
  #:use-module (gnu packages maths)
  #:use-module (gnu packages web)
  #:use-module (gnu packages fontutils)
  #:use-module (gnu packages freedesktop)
  #:use-module (gnu packages glib)
  #:use-module (gnu packages gperf)
  #:use-module (gnu packages imagemagick)
  #:use-module (gnu packages lua)
  #:use-module (gnu packages linux)
  #:use-module (gnu packages suckless)
  #:use-module (guix download)
  #:use-module (guix git-download))

(define-public libconfuse
  (package
    (name "libconfuse")
    (version "3.2.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://github.com/martinh/libconfuse/"
                                  "releases/download/v" version
                                  "/confuse-" version ".tar.xz"))
              (sha256
               (base32
                "0pnjmlj9i0alp407qd7c0vq83sz7gpsjrbdgpcn4xvzjp9r35ii3"))))
    (build-system gnu-build-system)
    (home-page "https://github.com/martinh/libconfuse")
    (synopsis "Configuration file parser library")
    (description "libconfuse is a configuration file parser library.  It
supports sections and (lists of) values (strings, integers, floats, booleans
or other sections), as well as some other features (such as
single/double-quoted strings, environment variable expansion, functions and
nested include statements).")
    (license license:isc)))

(define-public bspwm
  (package
    (name "bspwm")
    (version "0.9.3")
    (source
     (origin
       (file-name (string-append name "-" version ".tar.gz"))
       (method url-fetch)
       (uri (string-append
             "https://github.com/baskerville/bspwm/archive/"
             version ".tar.gz"))
       (sha256
        (base32
         "17dwj7w16cdj7g4s2y2f96lgj5msq1s4543dnfa3rijlazzy6mmk"))))
    (build-system gnu-build-system)
    (inputs
     `(("libxcb" ,libxcb)
       ("libxinerama" ,libxinerama)
       ("sxhkd" ,sxhkd)
       ("xcb-util" ,xcb-util)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-wm" ,xcb-util-wm)))
    (arguments
     '(#:phases (modify-phases %standard-phases (delete 'configure))
       #:tests? #f  ; no check target
       #:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" %output))))
    (home-page "https://github.com/baskerville/bspwm")
    (synopsis "Tiling window manager based on binary space partitioning")
    (description "bspwm is a tiling window manager that represents windows as
the leaves of a full binary tree.")
    (license license:bsd-2)))

(define-public i3status
  (package
    (name "i3status")
    (version "2.11")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://i3wm.org/i3status/i3status-"
                                  version ".tar.bz2"))
              (sha256
               (base32
                "0pwcy599fw8by1a1sf91crkqba7679qhvhbacpmhis8c1xrpxnwq"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags (list "CC=gcc" (string-append "PREFIX=" %output))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))
       #:tests? #f)) ; no test suite
    (inputs
     `(("openlibm" ,openlibm)
       ("libconfuse" ,libconfuse)
       ("libyajl" ,libyajl)
       ("alsa-lib" ,alsa-lib)
       ("pulseaudio" ,pulseaudio)
       ("libnl" ,libnl)
       ("libcap" ,libcap)
       ("asciidoc" ,asciidoc)))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (home-page "https://i3wm.org/i3status/")
    (synopsis "Status bar for i3bar, dzen2, xmobar or similar programs")
    (description "i3status is a small program for generating a status bar for
i3bar, dzen2, xmobar or similar programs.  It is designed to be very efficient
by issuing a very small number of system calls, as one generally wants to
update such a status line every second.  This ensures that even under high
load, your status bar is updated correctly.  Also, it saves a bit of energy by
not hogging your CPU as much as spawning the corresponding amount of shell
commands would.")
    (license license:bsd-3)))

(define-public i3-wm
  (package
    (name "i3-wm")
    (version "4.14.1")
    (source (origin
              (method url-fetch)
              (uri (string-append "https://i3wm.org/downloads/i3-"
                                  version ".tar.bz2"))
              (sha256
               (base32
                "1cazmfbbx6n8c81h6x6pdayq3mxs2ml3adz165z8vapkc72kl1nh"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags
       (list "CC=gcc"
             (string-append "PREFIX=" %output)
             ;; This works around the following error:
             ;; 'error: ‘for’ loop initial declarations are only allowed in C99
             ;; or C11 mode'
             "CFLAGS=-std=c11")
       ;; The build system tries to build in a separate directory, but that
       ;; seems to be unnecessary.
       #:configure-flags '("--disable-builddir")
       ;; The test suite appears to require the unpackaged Perl module AnyEvent.
       #:tests? #f))
    (inputs
     `(("libxcb" ,libxcb)
       ("xcb-util" ,xcb-util)
       ("xcb-util-cursor" ,xcb-util-cursor)
       ("xcb-util-keysyms" ,xcb-util-keysyms)
       ("xcb-util-wm" ,xcb-util-wm)
       ("xcb-util-xrm" ,xcb-util-xrm)
       ("libxkbcommon" ,libxkbcommon)
       ("libev" ,libev)
       ("libyajl" ,libyajl)
       ("asciidoc" ,asciidoc)
       ("xmlto" ,xmlto)
       ("perl-pod-simple" ,perl-pod-simple)
       ("libx11" ,libx11)
       ("pcre" ,pcre)
       ("startup-notification" ,startup-notification)
       ("pango" ,pango)
       ("cairo" ,cairo)))
    (native-inputs
     `(("which" ,which)
       ("perl" ,perl)
       ("pkg-config" ,pkg-config)
       ;; For building the documentation.
       ("libxml2" ,libxml2)
       ("docbook-xsl" ,docbook-xsl)))
    (home-page "https://i3wm.org/")
    (synopsis "Improved tiling window manager")
    (description "A tiling window manager, completely written
from scratch.  i3 is primarily targeted at advanced users and
developers.")
    (license license:bsd-3)))

(define-public perl-anyevent-i3
  (package
    (name "perl-anyevent-i3")
    (version "0.17")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://cpan/authors/id/M/MS/MSTPLBG/"
                                  "AnyEvent-I3-" version ".tar.gz"))
              (sha256
               (base32
                "0qvd9bq16jyy7v3ma82qcnvz9j503bw0mh7h55gkjf7ir62ck0jk"))))
    (build-system perl-build-system)
    (propagated-inputs
     `(("perl-anyevent" ,perl-anyevent)
       ("perl-json-xs" ,perl-json-xs)))
    (home-page "http://search.cpan.org/dist/AnyEvent-I3")
    (synopsis
     "Communicate with the i3 window manager through perl")
    (description
     "This module connects to the i3 window manager using the UNIX socket
based IPC interface it provides (if enabled in the configuration file).
You can then subscribe to events or send messages and receive their replies.")
    ;; Can be used with either license.
    (license (list license:gpl3+ license:perl-license))))

(define-public python-i3-py
  (package
    (name "python-i3-py")
    (version "0.6.5")
    (source
     (origin
       ;; The latest release is not tagged in Git nor has an entry in PyPi,
       ;; but there is still a clear commit for it, and it's been the last one
       ;; for years.
       (method git-fetch)
       (uri (git-reference
             (url "https://github.com/ziberna/i3-py.git")
             (commit "27f88a616e9ecc340e7d041d3d00782f8a1964c1")))
       (sha256
        (base32
         "1nm719dc2xqlll7vj4c4m7mpjb27lpn3bg3c66gajvnrz2x1nmxs"))
       (file-name (string-append name "-" version "-checkout"))))
    (build-system python-build-system)
    (arguments
     `(#:tests? #f ; no tests yet
       #:phases (modify-phases %standard-phases
                  (add-after 'install 'install-doc
                    ;; Copy readme file to documentation directory.
                    (lambda* (#:key outputs #:allow-other-keys)
                      (let ((doc (string-append (assoc-ref outputs "out")
                                                "/share/doc/" ,name)))
                        (install-file "README.md" doc)
                        ;; Avoid unspecified return value.
                        #t))))))
    (propagated-inputs
     `(("i3-wm" ,i3-wm)))
    (home-page "https://github.com/ziberna/i3-py")
    (synopsis "Python interface to the i3 window manager")
    (description "This package allows you to interact from a Python program
with the i3 window manager via its IPC socket.  It can send commands and other
kinds of messages to i3, select the affected containers, filter results and
subscribe to events.")
    (license license:gpl3+)))

(define-public python2-i3-py
  (package-with-python2 python-i3-py))

(define-public quickswitch-i3
  (let ((commit "ed692b1e8f43b95bd907ced26238ce8ccb2ed28f")
        (revision "1")) ; Guix package revision
    (package
      (name "quickswitch-i3")
      (version (string-append "2.2-" revision "."
                              (string-take commit 7)))
      (source
       (origin
         ;; The latest commit is a few years old and just a couple commits
         ;; after the last tagged release, so we use that latest commit
         ;; instead of the release.
         (method git-fetch)
         (uri (git-reference
               (url "https://github.com/proxypoke/quickswitch-for-i3.git")
               (commit commit)))
         (sha256
          (base32
           "0447077sama80jcdg5p64zjsvafmz5rbdrirhm1adcdjhkh6iqc5"))
         (patches (search-patches "quickswitch-fix-dmenu-check.patch"))
         (file-name (string-append name "-" version "-checkout"))))
      (build-system python-build-system)
      (arguments
       `(#:tests? #f ; no tests yet
         #:phases (modify-phases %standard-phases
                    (add-after 'install 'install-doc
                      ;; Copy readme file to documentation directory.
                      (lambda* (#:key outputs #:allow-other-keys)
                        (let ((doc (string-append (assoc-ref outputs "out")
                                                  "/share/doc/" ,name)))
                          (install-file "README.rst" doc)
                          ;; Avoid unspecified return value.
                          #t))))))
      (inputs
       `(("python-i3-py" ,python-i3-py)
         ("dmenu" ,dmenu)))
      (home-page "https://github.com/proxypoke/quickswitch-for-i3")
      (synopsis "Quickly change to and locate windows in the i3 window manager")
      (description
       "This utility for the i3 window manager allows you to quickly switch to
and locate windows on all your workspaces, using an interactive dmenu
prompt.")
      (license (license:non-copyleft "http://www.wtfpl.net/txt/copying/")))))

(define-public i3lock-color
  (package
    (name "i3lock-color")
    (version "2.10.1c")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/PandorasFox/i3lock-color/"
                           "archive/" version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "119xvdm4r6irqk0mar80hx6s8ydw26y35h7712rd7nbg7pb7i053"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ;No tests included.
       #:phases
       (modify-phases %standard-phases
         (add-after 'unpack 'bootstrap
           (lambda _
             (zero? (system* "autoreconf" "-vfi")))))))
    (inputs
     `(("xcb-util-image" ,xcb-util-image)
       ("xcb-util" ,xcb-util)
       ("libxcb" ,libxcb)
       ("linux-pam" ,linux-pam)
       ("libxkbcommon" ,libxkbcommon)
       ("libev" ,libev)
       ("cairo" ,cairo)))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("autoconf" ,autoconf)
        ("automake" ,automake)))
    (home-page "https://github.com/PandorasFox/i3lock-color")
    (synopsis "Screen locker with color configuration support")
    (description
     "i3lock-color is a simpler X11 screen locker derived from i3lock.
Features include:

@enumerate
@item forking process, the locked screen is preserved when you suspend to RAM;
@item specify background color or image to be displayed in the lock screen;
@item many additional color options.
@end enumerate")
    (license license:bsd-3)))

(define-public i3lock-fancy
  (package
    (name "i3lock-fancy")
    (version "0.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/meskarune/i3lock-fancy/archive/"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "020m7mnfq5cvir7p9v3hkb7cvb4cai33wppxl2zdwscwwjnchc5y"))))
    (build-system gnu-build-system)
    (arguments
     `(#:tests? #f ;No tests included
       #:phases
       (modify-phases %standard-phases
         (replace 'configure
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (icons (string-append out "/share/i3lock-fancy/icons/"))
                    (wmctrl (string-append (assoc-ref inputs "wmctrl")
                                           "/bin/wmctrl"))
                    (mconvert (string-append (assoc-ref inputs "imagemagick")
                                             "/bin/convert"))
                    (mimport (string-append (assoc-ref inputs "imagemagick")
                                            "/bin/import"))
                    (awk (string-append (assoc-ref inputs "gawk")
                                        "/bin/gawk")))

               (substitute* "lock"
                 (("$(which wmctrl)") wmctrl)
                 (("convert") mconvert)
                 (("shot=\\(import") (string-append "shot=\(" mimport))
                 (("awk -F") (string-append awk " -F"))
                 ((" awk") awk)
                 (("\\$scriptpath/icons/") icons))
               #t)))
         (delete 'build)
         (replace 'install
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((out (assoc-ref outputs "out"))
                    (bin (string-append out "/bin"))
                    (icons (string-append out "/share/i3lock-fancy/icons/")))

               (install-file "lock" bin)
               (rename-file (string-append bin "/lock")
                            (string-append bin "/i3lock-fancy"))
               (copy-recursively "icons" icons)
               #t))))))
    (native-inputs
     `(("imagemagick" ,imagemagick)
       ("wmctrl" ,wmctrl)
       ("gawk" ,gawk)))
    (home-page "https://github.com/meskarune/i3lock-fancy")
    (synopsis "Screen locker with screenshot function")
    (description
     "@code{i3lock-fancy} is a Bash script that takes a screenshot of
the desktop, blurs the background and adds a lock icon and text.
It requires @code{i3lock-color} or @code{i3lock} and can optionally
be passed any screenshot util like @code{scrot}.
This screen locker can be used with any window manager or
desktop environment.")
    (license license:expat)))

(define-public xmonad
  (package
    (name "xmonad")
    (version "0.13")
    (synopsis "Tiling window manager")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://hackage/package/xmonad/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "1jh3lcs20qpna36fa5a0r174xqrsxhj10x1rm5vwf64zariipy7r"))))
    (build-system haskell-build-system)
    (inputs
     `(("ghc-extensible-exceptions" ,ghc-extensible-exceptions)
       ("ghc-mtl"                   ,ghc-mtl)
       ("ghc-quickcheck"            ,ghc-quickcheck)
       ("ghc-setlocale"             ,ghc-setlocale)
       ("ghc-utf8-string"           ,ghc-utf8-string)
       ("ghc-directory"             ,ghc-directory)
       ("ghc-x11"                   ,ghc-x11)))
    (arguments
     `(#:phases
       (modify-phases %standard-phases
         (add-after
          'install 'install-xsession
          (lambda _
            (let* ((xsessions (string-append %output "/share/xsessions")))
              (mkdir-p xsessions)
              (call-with-output-file
                  (string-append xsessions "/xmonad.desktop")
                (lambda (port)
                  (format port "~
                    [Desktop Entry]~@
                    Name=~a~@
                    Comment=~a~@
                    Exec=~a/bin/xmonad~@
                    Type=Application~%" ,name ,synopsis %output)))))))))
    (home-page "http://xmonad.org")
    (description
     "Xmonad is a tiling window manager for X.  Windows are arranged
automatically to tile the screen without gaps or overlap, maximising screen
use.  All features of the window manager are accessible from the keyboard: a
mouse is strictly optional.  Xmonad is written and extensible in Haskell.
Custom layout algorithms, and other extensions, may be written by the user in
config files.  Layouts are applied dynamically, and different layouts may be
used on each workspace.  Xinerama is fully supported, allowing windows to be
tiled on several screens.")
    (license license:bsd-3)))

(define-public xmobar
  (package
    (name "xmobar")
    (version "0.25")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://hackage/package/xmobar/"
                                  name "-" version ".tar.gz"))
              (sha256
               (base32
                "0382r4vzqkz76jlp2069rdbwf4gh1a22r9w4rkphcn5qflw0dlb6"))))
    (build-system haskell-build-system)
    (inputs
     `(("ghc-hinotify" ,ghc-hinotify)
       ("ghc-http" ,ghc-http)
       ("ghc-iwlib" ,ghc-iwlib)
       ("ghc-parsec" ,ghc-parsec)
       ("ghc-regex-compat" ,ghc-regex-compat)
       ("ghc-stm" ,ghc-stm)
       ("ghc-x11-xft" ,ghc-x11-xft)
       ("libxpm" ,libxpm)))
    (arguments
     `(#:configure-flags
       (list (string-append "--flags="
                            (string-join (list "with_inotify"
                                               "with_iwlib"
                                               "with_utf8"
                                               "with_weather"
                                               "with_xft"
                                               "with_xpm")
                                         " ")))))
    (home-page "http://xmobar.org")
    (synopsis "Minimalistic text based status bar")
    (description
     "@code{xmobar} is a lightweight, text-based, status bar written in
Haskell.  It was originally designed to be used together with Xmonad, but it
is also usable with any other window manager.  While xmobar is written in
Haskell, no knowledge of the language is required to install and use it.")
    (license license:bsd-3)))

(define-public ghc-xmonad-contrib
  (package
    (name "ghc-xmonad-contrib")
    (version "0.13")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://hackage/package/xmonad-contrib/"
                           "xmonad-contrib-" version ".tar.gz"))
       (sha256
        (base32
         "0vj72jhfng6y7hv5frx2v99jvl3jn9rbpk2j7xw9vydiwmzq4q57"))))
    (build-system haskell-build-system)
    (propagated-inputs
     `(("ghc-mtl" ,ghc-mtl)
       ("ghc-old-time" ,ghc-old-time)
       ("ghc-random" ,ghc-random)
       ("ghc-utf8-string" ,ghc-utf8-string)
       ("ghc-extensible-exceptions" ,ghc-extensible-exceptions)
       ("ghc-x11" ,ghc-x11)
       ("ghc-x11-xft" ,ghc-x11-xft)
       ("xmonad" ,xmonad)))
    (home-page "http://xmonad.org")
    (synopsis "Third party extensions for xmonad")
    (description
     "Third party tiling algorithms, configurations, and scripts to Xmonad, a
tiling window manager for X.")
    (license license:bsd-3)))

(define-public evilwm
  (package
    (name "evilwm")
    (version "1.1.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://www.6809.org.uk/evilwm/evilwm-"
                           version ".tar.gz"))
       (sha256
        (base32
         "0ak0yajzk3v4dg5wmaghv6acf7v02a4iw8qxmq5yw5ard8lrqn3r"))
       (patches (search-patches "evilwm-lost-focus-bug.patch"))))
    (build-system gnu-build-system)
    (inputs
     `(("libx11" ,libx11)
       ("libxext" ,libxext)
       ("libxrandr" ,libxrandr)))
    (arguments
     `(#:modules ((srfi srfi-26)
                  (guix build utils)
                  (guix build gnu-build-system))
       #:make-flags (let ((inputs (map (cut assoc-ref %build-inputs <>)
                                       '("libx11" "libxext" "libxrandr")))
                          (join (lambda (proc strs)
                                  (string-join (map proc strs) " ")))
                          (dash-I (cut string-append "-I" <> "/include"))
                          (dash-L (cut string-append "-L" <> "/lib")))
                      `("desktopfilesdir=$(prefix)/share/xsessions"
                        ,(string-append "prefix=" (assoc-ref %outputs "out"))
                        ,(string-append "CPPFLAGS=" (join dash-I inputs))
                        ,(string-append "LDFLAGS=" (join dash-L inputs))))
       #:tests? #f                      ;no tests
       #:phases (modify-phases %standard-phases
                  (delete 'configure)))) ;no configure script
    (home-page "http://www.6809.org.uk/evilwm/")
    (synopsis "Minimalist window manager for the X Window System")
    (description
     "evilwm is a minimalist window manager based on aewm, extended to feature
many keyboard controls with repositioning and maximize toggles, solid window
drags, snap-to-border support, and virtual desktops.")
    (license (license:x11-style "file:///README"))))

(define-public fluxbox
  (package
    (name "fluxbox")
    (version "1.3.7")
    (synopsis "Small and fast window manager")
    (source (origin
              (method url-fetch)
              (uri (string-append "mirror://sourceforge/fluxbox/fluxbox/"
                                  version "/fluxbox-" version ".tar.xz"))
              (sha256
               (base32
                "1h1f70y40qd225dqx937vzb4k2cz219agm1zvnjxakn5jkz7b37w"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags '("CPPFLAGS=-U__TIME__") ;ugly, but for reproducibility
       #:phases
       (modify-phases %standard-phases
         (add-after
          'install 'install-xsession
          (lambda _
            (let ((xsessions (string-append %output "/share/xsessions")))
              (mkdir-p xsessions)
              (call-with-output-file
                  (string-append xsessions "/fluxbox.desktop")
                (lambda (port)
                  (format port "~
                    [Desktop Entry]~@
                    Name=~a~@
                    Comment=~a~@
                    Exec=~a/bin/startfluxbox~@
                    Type=Application~%" ,name ,synopsis %output)))))))))
    (native-inputs
     `(("pkg-config" ,pkg-config)))
    (inputs
     `(("freetype" ,freetype)
       ("fribidi" ,fribidi)
       ("imlib2" ,imlib2)
       ("libx11" ,libx11)
       ("libxext" ,libxext)
       ("libxft" ,libxft)
       ("libxinerama" ,libxinerama)
       ("libxpm"  ,libxpm)
       ("libxrandr" ,libxrandr)
       ("libxrender" ,libxrender)))
    (description "Fluxbox is a window manager.  It is light on resources
and easy to handle yet full of features to make an easy and fast desktop
experience.")
    (home-page "http://fluxbox.org/")
    (license license:expat)))

(define-public awesome
  (package
    (name "awesome")
    (version "4.2")
    (source
     (origin (method url-fetch)
             (uri (string-append
                   "https://github.com/awesomeWM/awesome-releases/raw/"
                   "master/awesome-" version ".tar.xz"))
             (sha256
              (base32
               "0kwpbls9h1alxcmvxh5g9qb995fds5b2ngcr44w0ibazkyls2pdc"))
             (modules '((guix build utils)
                        (srfi srfi-19)))
             (snippet
              ;; Remove non-reproducible timestamp and use the date of the
              ;; source file instead.
              '(substitute* "common/version.c"
                 (("__DATE__ \" \" __TIME__")
                  (date->string
                   (time-utc->date
                    (make-time time-utc 0
                               (stat:mtime (stat "awesome.c"))))
                   "\"~c\""))))
             (patches (search-patches "awesome-reproducible-png.patch"))))
    (build-system cmake-build-system)
    (native-inputs `(("asciidoc" ,asciidoc)
                     ("docbook-xsl" ,docbook-xsl)
                     ("doxygen" ,doxygen)
                     ("gperf" ,gperf)
                     ("imagemagick" ,imagemagick)
                     ("libxml2" ,libxml2)         ;for XML_CATALOG_FILES
                     ("pkg-config" ,pkg-config)
                     ("xmlto" ,xmlto)))
    (inputs `(("cairo" ,cairo)
              ("dbus" ,dbus)
              ("gdk-pixbuf" ,gdk-pixbuf)
              ("glib" ,glib)
              ("gobject-introspection" ,gobject-introspection)
              ("imlib2" ,imlib2)
              ("libev" ,libev)
              ("libxcb" ,libxcb)
              ("libxcursor" ,libxcursor)
              ("libxdg-basedir" ,libxdg-basedir)
              ("libxkbcommon" ,libxkbcommon)
              ("lua" ,lua)
              ("lua-lgi",lua-lgi)
              ("pango" ,pango)
              ("startup-notification" ,startup-notification)
              ("xcb-util" ,xcb-util)
              ("xcb-util-cursor" ,xcb-util-cursor)
              ("xcb-util-image" ,xcb-util-image)
              ("xcb-util-keysyms" ,xcb-util-keysyms)
              ("xcb-util-renderutil" ,xcb-util-renderutil)
              ("xcb-util-xrm" ,xcb-util-xrm)
              ("xcb-util-wm" ,xcb-util-wm)))
    (arguments
     `(;; Let compression happen in our 'compress-documentation' phase so that
       ;; '--no-name' is used, which removes timestamps from gzip output.
       #:configure-flags '("-DCOMPRESS_MANPAGES=off")

       ;; Building awesome in its source dir is no longer supported.
       #:out-of-source? #t

       #:phases
       (modify-phases %standard-phases
         (add-before 'build 'xmlto-skip-validation
           (lambda _
             ;; We can't download the necessary schema, so so skip
             ;; validation and assume they're valid.
             (substitute* "../build/CMakeFiles/man.dir/build.make"
               (("/xmlto")
                (string-append "/xmlto --skip-validation")))
             #t))
         (add-before 'configure 'set-lua-paths
           (lambda* (#:key inputs #:allow-other-keys)
             ;; The build process needs to load cairo dynamically.
             (let* ((cairo (string-append
                             (assoc-ref inputs "cairo") "/lib" ))
                    (lua-lgi (assoc-ref inputs "lua-lgi") ))
               (setenv "LD_LIBRARY_PATH" cairo )
               (setenv "LUA_PATH" (string-append lua-lgi
                                                 "/share/lua/5.2/?.lua"))
               (setenv "LUA_CPATH" (string-append lua-lgi
                                                  "/lib/lua/5.2/?.so"))
               #t)))
         (replace 'check
           (lambda _
             ;; There aren't any tests, so just make sure the binary
             ;; gets built and can be run successfully.
             (zero? (system* "../build/awesome" "-v"))))
         (add-after 'install 'wrap
           (lambda* (#:key inputs outputs #:allow-other-keys)
             (let* ((awesome (assoc-ref outputs "out"))
                    (cairo (string-append
                             (assoc-ref inputs "cairo") "/lib" ))
                    (lua-lgi (assoc-ref inputs "lua-lgi") ))
               (wrap-program (string-append awesome "/bin/awesome")
                 `("GI_TYPELIB_PATH" ":" prefix (,(getenv "GI_TYPELIB_PATH")))
                 `("LD_LIBRARY_PATH" suffix (, cairo))
                 `("LUA_PATH" suffix (,(string-append lua-lgi
                                                      "/share/lua/5.2/?.lua")))
                 `("LUA_CPATH" suffix (,(string-append
                                          lua-lgi "/lib/lua/5.2/?.so"))))))))))
    (synopsis "Highly configurable window manager")
    (description
     "Awesome has been designed as a framework window manager.  It is fast, small,
dynamic and extensible using the Lua programming language.")
    (license license:gpl2+)
    (home-page "https://awesome.naquadah.org/")))

(define-public menumaker
  (package
    (name "menumaker")
    (version "0.99.10")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "mirror://sourceforge/menumaker/"
                           "menumaker-" version ".tar.gz"))
       (sha256
        (base32
         "1mm4cvg3kphkkd8nwrhcg6d9nm5ar7mgc0wf6fxk6zck1l7xn8ky"))))
    (build-system gnu-build-system)
    (inputs
     `(("python" ,python)))
    (synopsis "Heuristics-driven menu generator")
    (description
     "MenuMaker is a menu generation utility for a number of X window
managers and desktop environments.  It is capable of finding lots of
installed programs and generating a root menu consistent across all
supported window managers, so one will get (almost) the same menu in
all of them.  Currently supported window managers include:

@enumerate
@item BlackBox
@item Deskmenu
@item FluxBox
@item IceWM
@item OpenBox
@item PekWM
@item WindowMaker
@item XFCE
@end enumerate\n")
    (home-page "http://menumaker.sourceforge.net/")
    (license license:bsd-2)))

(define-public keybinder
  (package
    (name "keybinder")
    (version "0.3.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/kupferlauncher/keybinder"
                           "/releases/download/v" version "/keybinder-"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "0h52hj3ay8mfhwvmfxbxlfyq74hifdk8wxgxp7fr4iy6189hg7w7"))))
    (build-system gnu-build-system)
    (inputs
     `(("python-2" ,python-2)
       ("gtk+-2" ,gtk+-2)))
    (native-inputs
     `(("python2-pygtk" ,python2-pygtk)
       ("gtk-doc" ,gtk-doc)
       ("pkg-config" ,pkg-config)))
    (synopsis "Library for registering global keyboard shortcuts")
    (description
     "Keybinder is a library for registering global keyboard shortcuts.
Keybinder works with GTK-based applications using the X Window System.")
    (home-page "https://github.com/kupferlauncher/keybinder")
    (license license:gpl2+)))

(define-public spectrwm
  (package
    (name "spectrwm")
    (version "3.1.0")
    (source
     (origin
       (method url-fetch)
       (uri (let ((version-with-underscores
                   (string-join (string-split version #\.) "_")))
              (string-append "https://github.com/conformal/spectrwm/archive/"
                             "SPECTRWM_" version-with-underscores ".tar.gz")))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "16lxcharxslf9rc39wxa3mr2nx5d8kzm9ls7p7dal8yrwr7y59dp"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags (let ((pkg-config (lambda (flag)
                                        (string-append
                                         "$(shell pkg-config " flag " "
                                         "xft fontconfig x11 libpng)"))))
                      (list
                       "CC=gcc"
                       (string-append "PREFIX=" %output)
                       (string-append "INCS=-I. " (pkg-config "--cflags"))
                       (string-append "LIBS=" (pkg-config "--libs") " -lm")))
       #:tests? #f ;No test suite
       #:phases
       (modify-phases %standard-phases
         (add-before 'build 'change-dir
           (lambda _
             (chdir "linux") #t))
         (add-after 'change-dir 'patch-makefile
           (lambda _
             (substitute* "Makefile"
               (("-g") ""))))
         (add-after 'change-dir 'fix-freetype-include
           (lambda _
             (substitute* "Makefile"
               (("/usr/include/freetype2")
                (string-append (assoc-ref %build-inputs "freetype")
                               "/include/freetype2")))))
         (delete 'configure))))                   ;no 'configure' exists
    (inputs
     `(("freetype" ,freetype)
       ("fontconfig" ,fontconfig)
       ("libx11" ,libx11)
       ("libxcursor" ,libxcursor)
       ("libxrandr" ,libxrandr)
       ("libxtst" ,libxtst)
       ("libxft" ,libxft)
       ("xcb-util" ,xcb-util)
       ("xcb-util-wm" ,xcb-util-wm)
       ("xcb-util-keysyms" ,xcb-util-keysyms)))
    (native-inputs
     `(("libxt" ,libxt)
       ("pkg-config" ,pkg-config)))
    (synopsis "Minimalistic automatic tiling window manager")
    (description
     "Spectrwm is a small dynamic tiling and reparenting window manager for X11.
It is inspired by Xmonad and dwm.  Its major features include:

@itemize
@item Navigation anywhere on all screens with either the keyboard or mouse
@item Customizable status bar
@item Restartable without losing state
@item Quick launch menu
@item Many screen layouts possible with a few simple key strokes
@item Move/resize floating windows
@item Extended Window Manager Hints (@dfn{EWMH}) support
@item Configurable tiling
@item Adjustable tile gap allows for a true one pixel border
@item Customizable colors and border width
@end itemize\n")
    (home-page "https://github.com/conformal/spectrwm")
    (license license:isc)))

(define-public cwm
  (package
    (name "cwm")
    (version "6.2")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "http://chneukirchen.org/releases/cwm-"
                           version ".tar.gz"))
       (sha256
        (base32
         "1b8k2hjxpb0bzqjh2wj6mn2nf2360zacf8z19sw2rw5lxvmfy89x"))))
    (build-system gnu-build-system)
    (arguments
     `(#:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" %output))
       #:tests? #f
       #:phases
       (modify-phases %standard-phases
         (delete 'configure)
         (add-after 'build 'install-xsession
           (lambda* (#:key outputs #:allow-other-keys)
             ;; Add a .desktop file to xsessions.
             (let* ((output (assoc-ref outputs "out"))
                    (xsessions (string-append output "/share/xsessions")))
               (mkdir-p xsessions)
               (with-output-to-file
                   (string-append xsessions "/cwm.desktop")
                 (lambda _
                   (format #t
                           "[Desktop Entry]~@
                     Name=cwm~@
                     Comment=OpenBSD Calm Window Manager fork~@
                     Exec=~a/bin/cwm~@
                     TryExec=~@*~a/bin/cwm~@
                     Icon=~@
                     Type=Application~%"
                           output)))
               #t))))))
    (inputs
     `(("libxft" ,libxft)
       ("libxrandr" ,libxrandr)
       ("libxinerama" ,libxinerama)))
    (native-inputs
     `(("pkg-config" ,pkg-config)
       ("bison" ,bison)))
    (home-page "https://github.com/chneukirchen/cwm")
    (synopsis "OpenBSD fork of the calmwm window manager")
    (description "Cwm is a stacking window manager for X11.  It is an OpenBSD
project derived from the original Calm Window Manager.")
    (license license:isc)))
