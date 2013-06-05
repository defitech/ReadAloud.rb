#import <Foundation/Foundation.h>

@interface ReadingControllerHelper : NSObject

@property (readonly) id readingController;

- (id) initForController: (id) controller withShortcutPrefKey: (NSString*) prefKey;

@end