#
#  ReadingController.rb
#  ReadAloud.rb
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

framework 'foundation'

class ReadingController
  attr_accessor :statusMenuItem
  attr_accessor :enableMenuItem
  attr_accessor :disableMenuItem

  def init
    @synthesizer = NSSpeechSynthesizer.alloc.init()
    @enabled = false
    
    NSLog("ReadingController: initialized (id #{self.object_id})")
    
    self
  end
  
  def enable(sender)
    # init pasteboard polling
    @pasteboard = NSPasteboard.generalPasteboard if not @pasteboard
    @previousPBChangeCount = @pasteboard.changeCount
    @pollTimer = NSTimer.scheduledTimerWithTimeInterval(0.25,
                                                        target:self,
                                                        selector:'checkPasteboardChange:',
                                                        userInfo:nil,
                                                        repeats:true)
    @enabled = true
    
    NSLog("ReadingController: enabled")
    
    updateView
  end
  
  def checkPasteboardChange(timer)
    curChangeCount = @pasteboard.changeCount
    return if curChangeCount == @previousPBChangeCount
    
    @previousPBChangeCount = curChangeCount
    
    NSLog("ReadingController: clipboard changed; reading...")
    
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    # reset voice to current system setting
    @synthesizer.setVoice(nil)
    # TODO: get pasteboard content, check if string, then read it
  end

  def disable(sender)
    @pollTimer.invalidate
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @enabled = false
    
    NSLog("ReadingController: disabled")
    
    updateView
  end
  
  def updateView
    # TODO use localized string
    statusMenuItem.setTitle(if @enabled then "Reading is enabled"
                            else "Reading is disabled" end)
    enableMenuItem.setHidden(@enabled)
    disableMenuItem.setHidden(! @enabled)
    
    NSLog("ReadingController: view updated")
  end
end