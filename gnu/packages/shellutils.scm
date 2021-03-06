;;; GNU Guix --- Functional package management for GNU
;;; Copyright © 2016 Matthew Jordan <matthewjordandevops@yandex.com>
;;; Copyright © 2016, 2017 Alex Griffin <a@ajgrf.com>
;;; Copyright © 2016 Christopher Baines <mail@cbaines.net>
;;; Copyright © 2017 Stefan Reichör <stefan@xsteve.at>
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

(define-module (gnu packages shellutils)
  #:use-module (gnu packages base)
  #:use-module (gnu packages golang)
  #:use-module (gnu packages python)
  #:use-module (guix licenses)
  #:use-module (guix packages)
  #:use-module (guix download)
  #:use-module (guix utils)
  #:use-module (guix build-system gnu)
  #:use-module (guix build-system python))

(define-public envstore
  (package
    (name "envstore")
    (version "2.1")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://finalrewind.org/projects/"
                           name "/" name "-" version ".tar.bz2"))
       (sha256
        (base32 "1x97lxad80m5blhdfanl5v2qzjwcgbij2i23701bn8mpyxsrqszi"))))
    (build-system gnu-build-system)
    (arguments
     `(#:test-target "test"
       #:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://finalrewind.org/projects/envstore/")
    (synopsis "Save and restore environment variables")
    (description "Envstore is a program for sharing environment variables
between various shells or commands.")
    (license
     (non-copyleft "http://www.wtfpl.net/txt/copying/"))))

(define-public trash-cli
  (package
    (name "trash-cli")
    (version "0.17.1.14")
    (source
     (origin
       (method url-fetch)
       (uri (pypi-uri "trash-cli" version))
       (sha256
        (base32
         "01q0cl04ljf214z6s3g256gsxx3pqsgaf6ac1zh0vrq5bnhnr85h"))))
    (build-system python-build-system)
    (arguments
     `(#:python ,python-2
       #:tests? #f ; no tests
       #:phases
       (modify-phases %standard-phases
         (add-before 'build 'patch-path-constants
           (lambda* (#:key inputs #:allow-other-keys)
             (let ((libc (assoc-ref inputs "libc"))
                   (coreutils (assoc-ref inputs "coreutils")))
               (substitute* "trashcli/list_mount_points.py"
                 (("\"/lib/libc.so.6\".*")
                  (string-append "\"" libc "/lib/libc.so.6\"\n"))
                 (("\"df\"")
                  (string-append "\"" coreutils "/bin/df\"")))))))))
    (inputs `(("coreutils" ,coreutils)))
    (home-page "https://github.com/andreafrancia/trash-cli")
    (synopsis "Trash can management tool")
    (description
     "trash-cli is a command line utility for interacting with the
FreeDesktop.org trash can used by GNOME, KDE, XFCE, and other common desktop
environments.  It can move files to the trash, and remove or list files that
are already there.")
    (license gpl2+)))

(define-public direnv
  (package
    (name "direnv")
    (version "2.11.3")
    (source
     (origin (method url-fetch)
             (uri (string-append "https://github.com/direnv/" name
                                 "/archive/v" version ".tar.gz"))
             (file-name (string-append name "-" version ".tar.gz"))
             (sha256
              (base32
               "01mhwzq9ss2qlnn8aahvwsgnspq8hbz0qfknf290aicngwx10d1d"))))
    (build-system gnu-build-system)
    (arguments
     '(#:test-target "test"
       #:make-flags (list (string-append "DESTDIR=" (assoc-ref %outputs "out")))
       #:phases (modify-phases %standard-phases (delete 'configure))))
    (native-inputs
      `(("go" ,go)
        ("which" ,which)))
    (home-page "https://direnv.net/")
    (synopsis "Environment switcher for the shell")
    (description
     "direnv can hook into the bash, zsh, tcsh, and fish shells to load
or unload environment variables depending on the current directory.  This
allows project-specific environment variables without using @file{~/.profile}.

Before each prompt, direnv checks for the existence of a @file{.envrc} file in
the current and parent directories.  This file is then used to alter the
environment variables of the current shell.")
    (license expat)))

(define-public fzy
  (package
    (name "fzy")
    (version "0.9")
    (source
     (origin
       (method url-fetch)
       (uri (string-append "https://github.com/jhawthorn/fzy/archive/"
                           version ".tar.gz"))
       (file-name (string-append name "-" version ".tar.gz"))
       (sha256
        (base32
         "1xfgxqbkcpi2n4381kj3fq4026qs6by7xhl5gn0fgp3dh232c63j"))))
    (build-system gnu-build-system)
    (arguments
     '(#:make-flags (list "CC=gcc"
                          (string-append "PREFIX=" (assoc-ref %outputs "out")))
       #:phases
       (modify-phases %standard-phases
         (delete 'configure))))
    (home-page "https://github.com/jhawthorn/fzy")
    (synopsis "Fast fuzzy text selector for the terminal with an advanced
scoring algorithm")
    (description
     "Most other fuzzy matchers sort based on the length of a match.  fzy tries
to find the result the user intended.  It does this by favouring matches on
consecutive letters and starts of words.  This allows matching using acronyms
or different parts of the path.

fzy is designed to be used both as an editor plugin and on the command
line.  Rather than clearing the screen, fzy displays its interface directly
below the current cursor position, scrolling the screen if necessary.")
    (license expat)))
