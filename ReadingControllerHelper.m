#import "ReadingControllerHelper.h"
#import "MASShortcut+UserDefaults.h"

@implementation ReadingControllerHelper

- (id) initForController: (id) controller withShortcutPrefKey: (NSString*) prefKey {
  self = [super init];
  _readingController = controller;
  
  [MASShortcut registerGlobalShortcutWithUserDefaultsKey:prefKey
                                                 handler:^{
                                                   [controller toggle:self];
                                                 }];
  
  return self;
}

@end