# ReadAloud.rb

A tiny OSX tool that reads aloud text copied to the clipboard, to workaround inconsistent system support when reading the selected text in apps.


## Features

- Status bar app (no dock icon)
- Reads aloud text when copied to the clipboard, using system-wide speech settings (accessible from the tool's preferences popup)
- Global shortcut for enabling/disabling the reading, configurable from the preferences popup
- Highly experimental spell checker—uses the Google Speech (unofficial) API to attempt to recognize the spoken original text
- Language support: English and French


## Requirements

For now the experimental spell checker requires the FLAC command-line utility to be installed beforehand. You can either:

- Use one of the OSX downloads on the [official FLAC page](http://flac.sourceforge.net/download.html) (the 'FLAC tools for OS X' will do fine)
- `brew install flac`, for those with [Homebrew](http://mxcl.github.io/homebrew/)


## Download binaries

- [Version 1.0.1](https://dl.dropboxusercontent.com/u/14379042/Apps%20publi%C3%A9es/ReadAloud-1.0.1.dmg)


## Disclaimer

This is a first-time project with all of Xcode, Cocoa and MacRuby, so there most likely are bad practices and/or blatant mistakes in the code.


## Acknowledgements

- This is a MacRuby port and evolution of the original [ReadAloud](https://github.com/defitech/ReadAloud) tool
- Global shortcut handling thanks to [shpakovski/MASShortcut](https://github.com/shpakovski/MASShortcut)
- App & status bar icon derived from [this one](http://thenounproject.com/noun/lips/#icon-No14820), designed by [Laetitia W. Merijon](http://thenounproject.com/laetitia.w.merijon) from The Noun Project