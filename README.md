zzz-scripted-screencast
=======================

Automates typing shell commands for a screencast

Synopsis
========

    $ ./scripted-screencast test-script.sh output.ogv

Prerequisites
=============

Executables:

* Perl 5 v5.10 or higher
* recordmydesktop

Perl Modules:

* File::Slurp
* IO::Prompt
* Term::ANSIColor

Usage
=====

    scripted-screencast <test-script> <output-file> [recorder options]
  
You may append any options supported by recordmydesktop and they will be passed
through.  Note that by default the output file does not overwrite an existing
file and a numbered variant name will be used instead.

When the program runs, you will be prompted to type "start" to begin.  This
gives the screen recorder time to launch in the background.

Once the screen is cleared, hit enter to see a scripted command "typed" on the screen.
Hit enter again to run the command.  Repeat until finished.

At the end of the script, hit enter on the blank prompt and you'll
get a message about the recorder shutting down.

Customizing
===========

The prompt is hardcoded to my preferred prompt style.  You'll probably want to
fork this repo and customize it to match *your* prompt style.

Or, maybe someone will contribute a patch to run an external program to display
the prompt and add a command line argument to use it.  (Wink, wink, nudge,
nudge if you are so inclined).

Known limitations
=================

This has only been tested on a recent Ubuntu on my laptop. YMMV.

Certain shell commands need to be intercepted ('cd' is already supported).
There are probably others needing similar treatment, but I haven't needed
them so I haven't implemented them.

Legal stuff
===========

The code in this repository is free software. It comes without any warranty, to
the extent permitted by applicable law. You can redistribute it and/or modify
it under the terms of the WTF Public Licence, Version 2, as published by Sam
Hocevar. See http://sam.zoy.org/wtfpl/COPYING for more details.
