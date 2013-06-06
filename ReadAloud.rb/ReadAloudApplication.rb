#
#  NSApplication subclass adding support for regular text keyboard shortcuts without an edit menu.
#
#  Created by dev on 06.06.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class ReadAloudApplication < NSApplication
  
  def sendEvent(event)
    if event.type == NSKeyDown
      eventModFlagMask = event.modifierFlags & NSDeviceIndependentModifierFlagsMask
      if eventModFlagMask == NSCommandKeyMask
        case event.charactersIgnoringModifiers
        when 'x'
          return if self.sendAction('cut:', to:nil, from:self)
        when 'c'
          return if self.sendAction('copy:', to:nil, from:self)
        when 'v'
          return if self.sendAction('paste:', to:nil, from:self)
        when 'z'
          return if self.sendAction('undo:', to:nil, from:self)
        when 'a'
          return if self.sendAction('selectAll:', to:nil, from:self)
        end
      elsif eventModFlagMask == NSCommandKeyMask | NSShiftKeyMask
        case event.charactersIgnoringModifiers
        when 'Z'
          return if self.sendAction('redo:', to:nil, from:self)
        end
      end
    end
    
    super(event)
  end

end