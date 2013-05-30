#
#  PreferencesController.rb
#  ReadAloud.rb
#
#  Created by dev on 30.05.13.
#  Copyright 2013 Defitech. All rights reserved.
#

class PreferencesWindowController < NSWindowController
  def init
    initWithWindowNibName('PreferencesWindow')
    self
  end
  
  def self.sharedPreferenceController
    @instance ||= alloc.init
  end
end