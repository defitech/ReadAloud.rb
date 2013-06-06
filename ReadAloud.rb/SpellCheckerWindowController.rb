#
#  Experimental spell checker using system speech synthesis & Google's Speech API recognition.
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

require 'json'

class SpellCheckerWindowController < NSWindowController
  attr_accessor :originalTextView
  attr_accessor :processButton
  attr_accessor :resultLabel
  attr_accessor :resultTextView
  attr_accessor :resultReadButton
  
  def loadWindow
    super

    @synthesizer = NSSpeechSynthesizer.alloc.init()
    
    # setup location for temp audio file
    tempDir = NSTemporaryDirectory()
    if tempDir == nil then tempDir = "/tmp" end
    tempFile = tempDir.stringByAppendingPathComponent('ReadAloud-SpellCheckerAudio.aiff')
    @tempFileURL = NSURL.fileURLWithPath(tempFile)
    
    # TODO: set locale from system
    @apiURL = NSURL.URLWithString("https://www.google.com/speech-api/v1/recognize?xjerr=1&client=chromium&lang=fr-FR")
    
    setResultLabelText(NSLocalizedString("Result", "Result"))
  end
  
  def showWindow(sender)
    super
    self.window.makeFirstResponder(@originalTextView)
  end
  
  def readOriginalText(sender)
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @synthesizer.setVoice(nil)
    @synthesizer.startSpeakingString(@originalTextView.string)
  end
  
  def readResultText(sender)
    @synthesizer.stopSpeaking if @synthesizer.isSpeaking
    @synthesizer.setVoice(nil)
    @synthesizer.startSpeakingString(@resultTextView.string)
  end
  
  def process(sender)
    # TODO: do processing in a separate thread and add a "spinner" to the window until done
    
    @synthesizer.setVoice(nil)
    
    originalText = @originalTextView.string
    return if originalText.length == 0
    
    if not @synthesizer.startSpeakingString(originalText,
                                            toURL:@tempFileURL)
      NSLog("Error speaking text to file '#{@tempFileURL.path}'")
      return
    end
    
    # wait for speech to complete
    runLoop = NSRunLoop.currentRunLoop
    while @synthesizer.isSpeaking
      runLoop.runMode(NSDefaultRunLoopMode,
                      beforeDate:NSDate.distantFuture)
    end

    # convert to FLAC
    
    task = NSTask.alloc.init
    task.setLaunchPath("/usr/local/bin/flac") # TODO: include flac processing in app
    task.setArguments([ "-f", @tempFileURL.path ])
    task.launch
    task.waitUntilExit # TODO: error handling

    flacURL = @tempFileURL.URLByDeletingPathExtension.URLByAppendingPathExtension('flac')
    
    NSLog("FLAC conversion OK to #{flacURL.path}")

    # query API
    
    request = NSMutableURLRequest.alloc.initWithURL(@apiURL)
    request.setHTTPMethod('POST')
    request.addValue("audio/x-flac; rate=22050",
                     forHTTPHeaderField:'Content-Type')
    reqData = NSData.dataWithContentsOfURL(flacURL)
    request.setHTTPBody(reqData)
    request.setValue("#{reqData.length}",
                     forHTTPHeaderField:'Content-length')
    
    responsePointer = Pointer.new(:object)
    errorPointer = Pointer.new(:object)
    responseData = NSURLConnection.sendSynchronousRequest(request,
                                                          returningResponse:responsePointer,
                                                          error:errorPointer)
    # TODO: error handling
    resultJSON = NSString.alloc.initWithData(responseData,
                                             encoding:NSUTF8StringEncoding)
    NSLog("API result JSON: #{resultJSON}")
    
    result = JSON.parse(resultJSON)

    hypotheses = result['hypotheses']
    if hypotheses.length > 0
      confidencePercent = (hypotheses[0]['confidence'] * 100).to_i
      setResultLabelText(NSLocalizedString("Result (%d%% confidence)",
                                           "Result (%d%% confidence)") % confidencePercent)
      @resultTextView.setString(hypotheses[0]['utterance'])
      setResultEnabled(true)
    else      
      setResultLabelText(NSLocalizedString("No result!", "No result!"))
      @resultTextView.setString(NSLocalizedString("The recognition process failed to produce a result.",
                                                  "The recognition process failed to produce a result."))
      setResultEnabled(false)
    end
  end
  
  private
  
  def setResultLabelText(text)
    @resultLabel.setStringValue(text)
    @resultLabel.sizeToFit
  end
  
  def setResultEnabled(enabled)
    @resultReadButton.setEnabled(enabled)
    @resultTextView.setSelectable(enabled)
    @resultTextView.setTextColor(if enabled then NSColor.controlTextColor
                                 else NSColor.disabledControlTextColor end)
  end
end