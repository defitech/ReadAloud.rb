#
#  ReadingController.rb
#  ReadAloud.rb
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class ReadingController
  GlobalShortcut = "GlobalShortcutReading"
  
  attr_accessor :statusMenuItem
  attr_accessor :enableMenuItem
  attr_accessor :disableMenuItem

  def init
    @enabled = false
    @pasteboard = nil
    @previousPBChangeCount = -1
    @pollTimer = nil
    @synthesizer = NSSpeechSynthesizer.alloc.init()
    
    # NSLog("ReadingController: initialized (id #{self.object_id})")
    
    @helper = ReadingControllerHelper.alloc.initForController(self,
                                                              withShortcutPrefKey:GlobalShortcut)

    self
  end
  
  def enable(sender)
    # init pasteboard polling
    @pasteboard = NSPasteboard.generalPasteboard if @pasteboard == nil
    @previousPBChangeCount = @pasteboard.changeCount
    @pollTimer = NSTimer.scheduledTimerWithTimeInterval(0.25,
                                                        target:self,
                                                        selector:'checkPasteboardChange:',
                                                        userInfo:nil,
                                                        repeats:true)
    @enabled = true
    
    # NSLog("ReadingController: enabled")
    
    updateView
  end
  
  def checkPasteboardChange(timer)
    curChangeCount = @pasteboard.changeCount
    return if curChangeCount == @previousPBChangeCount
    
    @previousPBChangeCount = curChangeCount
    
    # NSLog("ReadingController: clipboard changed; reading...")
    
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @synthesizer.setVoice(nil) # reset voice to current system setting
    copiedItems = @pasteboard.readObjectsForClasses([NSString],
                                                    options:{})
    return if copiedItems == nil or copiedItems.length == 0
    # the following currently causes an (apparently harmless) "unregistered thread" error
    # see ref (for example): https://github.com/MacRuby/MacRuby/issues/209
    @synthesizer.startSpeakingString(copiedItems[0])
  end

  def disable(sender)
    @pollTimer.invalidate
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @enabled = false
    
    # NSLog("ReadingController: disabled")
    
    updateView
  end
  
  def toggle(sender)
    if @enabled
      self.disable(sender)
    else
      self.enable(sender)
    end
  end
  
  def updateView
    status = if @enabled then "Reading is enabled" else "Reading is disabled" end
    statusMenuItem.setTitle(NSLocalizedString(status, status))
    enableMenuItem.setHidden(@enabled)
    disableMenuItem.setHidden(! @enabled)
    
    # NSLog("ReadingController: view updated")
  end
end