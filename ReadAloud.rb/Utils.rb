#
#  Miscellaneous basic utils.
#
#  Created by dev on 05.06.13.
#  Copyright 2013 Defitech. All rights reserved.
#

module Kernel
  private

  # Make NSLocalizedString macro equivalent for Ruby code
  def NSLocalizedString(key, value)
    NSBundle.mainBundle.localizedStringForKey(key, value:value, table:nil)
  end
end