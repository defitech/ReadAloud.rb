#
#  The app delegate.
#  Manages general aspects, e.g. status bar item or showing/closing preferences.
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class AppDelegate
  attr_accessor :statusMenu
  attr_accessor :statusItem
  attr_accessor :readingController
  
  def init
    @preferencesPopover = nil
    
    self
  end
  
  def applicationDidFinishLaunching(a_notification)
    @statusItem = NSStatusBar.systemStatusBar().statusItemWithLength(NSVariableStatusItemLength)
    @statusItem.setMenu(@statusMenu)
    @statusItem.setImage(NSImage.imageNamed('StatusBarIcon.pdf'))
    @statusItem.setAlternateImage(NSImage.imageNamed('StatusBarIcon-Alternate.pdf'))
    @statusItem.setHighlightMode(true)
    @statusItemView = @statusItem.valueForKey('window').contentView
    
    @statusMenu.setDelegate(self)
  end
  
  def menuNeedsUpdate(menu)
    @readingController.updateView
  end
  
  def openPreferences(sender)
    if @preferencesPopover == nil
      @preferencesPopover = NSPopover.alloc.init
      @preferencesPopover.contentViewController =
        PreferencesViewController.alloc.initWithNibName('PreferencesView',
                                                        bundle:nil)
    end

    return if @preferencesPopover.isShown
    
    @preferencesPopover.showRelativeToRect(@statusItemView.frame,
                                           ofView:@statusItemView,
                                           preferredEdge:NSMinYEdge)
  end
  
  def closePreferences(sender)
    return if @preferencesPopover == nil

    @preferencesPopover.close
  end
end
