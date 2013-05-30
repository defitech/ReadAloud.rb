#
#  AppDelegate.rb
#  ReadAloud.rb
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class AppDelegate
  attr_accessor :statusMenu
  attr_accessor :statusItem
  attr_accessor :readingController
  attr_accessor :preferencesWindowController
  
  def applicationDidFinishLaunching(a_notification)
    @statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    @statusItem.setMenu(@statusMenu)
    @statusItem.setTitle("R")
    @statusItem.setHighlightMode(true)
    
    @statusMenu.setDelegate(self)
  end
  
  def menuNeedsUpdate(menu)
    @readingController.updateView
  end
end
