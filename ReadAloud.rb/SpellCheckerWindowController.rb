#
#  Experimental spell checker using system speech synthesis & Google's Speech API recognition.
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class SpellCheckerWindowController < NSWindowController
  attr_accessor :originalTextView
  attr_accessor :processButton
  attr_accessor :resultTextView
  
  def loadWindow
    super
    @synthesizer = NSSpeechSynthesizer.alloc.init()
  end
  
  def showWindow(sender)
    super
    self.window.makeFirstResponder(@originalTextView)
  end
  
  def readOriginalText(sender)
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @synthesizer.setVoice(nil)
    @synthesizer.startSpeakingString(originalTextView.textStorage.string)
  end
  
  def readResultText(sender)
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @synthesizer.setVoice(nil)
    @synthesizer.startSpeakingString(resultTextView.textStorage.string)
  end
  
  def process(sender)
    @synthesizer.setVoice(nil)
    NSLog("TODO: process...")
  end
end