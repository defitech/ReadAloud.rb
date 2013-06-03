#
#  PreferencesViewController.rb
#  ReadAloud.rb
#
#  Created by dev on 31.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class PreferencesViewController < NSViewController
  def openSystemPrefsPane(sender)
    errorsPointer = Pointer.new(:object)
    getOpenPrefsPaneScript.executeAndReturnError(errorsPointer)    
    NSApplication.sharedApplication.delegate.closePreferences(self)
  end
  
  def close(sender)
    NSApplication.sharedApplication.delegate.closePreferences(self)
  end

  private

  def getOpenPrefsPaneScript
    if @openPrefsPaneScript == nil
      scriptSrc = <<-eos
        tell application "System Preferences"
          activate
          set the current pane to pane id "com.apple.preference.speech"
          get the name of every anchor of pane id "com.apple.preference.speech"
          reveal anchor "TTS" of pane id "com.apple.preference.speech"
        end tell
      eos
      @openPrefsPaneScript = NSAppleScript.alloc.initWithSource(scriptSrc)
    end
    @openPrefsPaneScript
  end
end