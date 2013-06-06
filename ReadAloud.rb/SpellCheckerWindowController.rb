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
  attr_accessor :resultTextView
  
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
    
    @processingTask = nil
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
    # TODO: do processing in a separate thread and add a "spinner" to the window until done
    
    @synthesizer.setVoice(nil)
    
    originalText = originalTextView.textStorage.string
    return if originalText.length == 0
    
    NSLog("About to process...")
    
    if not @synthesizer.startSpeakingString(originalText,
                                            toURL:@tempFileURL)
      NSLog("Error speaking text to temp file")
      return
    end
    
    # wait for speaking to finish
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
    
    NSLog("FLAC conversion OK")

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
    responseJSON = NSString.alloc.initWithData(responseData,
                                               encoding:NSUTF8StringEncoding)
    NSLog("API response JSON: #{responseJSON}")
    
    response = JSON.parse(responseJSON)
    
    resultTextView.string = response['hypotheses'][0]['utterance']
  end
end