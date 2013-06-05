//
//  Listens for the global shortcut trigger on behalf of the ReadingController
//  (see the latter for more info).
//
//  Created by dev on 30.05.13.
//  Copyright 2013 Defitech. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ReadingControllerHelper : NSObject

@property (readonly) id readingController;

- (id) initForController: (id) controller withShortcutPrefKey: (NSString*) prefKey;

@end