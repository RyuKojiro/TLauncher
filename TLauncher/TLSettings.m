//
//  TLSettings.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "TLSettings.h"

@implementation TLSettings

- (NSString *) actionForFileExtension:(NSString *)extension {
	return @"$EDITOR";
}

@end
