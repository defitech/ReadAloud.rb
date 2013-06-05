# ReadAloud.rb

A tiny OSX tool that reads aloud text copied to the clipboard, to workaround inconsistent system support when reading the selected text in apps.


## Features

- Status bar app (no dock icon)
- Reads aloud text when copied to the clipboard, using system-wide speech settings (accessible from the tool's preferences popup)
- Global shortcut for enabling/disabling the reading, configurable from the preferences popup
- Language support: English and French


## Disclaimer

This is a first-time project with all of Xcode, Cocoa and MacRuby, so there most likely are bad practices and/or blatant mistakes in the code.


## Acknowledgements

- This is a MacRuby port and evolution of the original [ReadAloud](https://github.com/defitech/ReadAloud) tool
- Global shortcut handling thanks to [shpakovski/MASShortcut](https://github.com/shpakovski/MASShortcut)
- Status bar icon derived from [this one](http://thenounproject.com/noun/lips/#icon-No14820), designed by [Laetitia W. Merijon](http://thenounproject.com/laetitia.w.merijon) from The Noun Project