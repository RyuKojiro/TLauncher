//
//  TLSettings.h
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface TLSettings : NSArrayController

- (NSString *) actionForFileExtension:(NSString *)extension;

@end
