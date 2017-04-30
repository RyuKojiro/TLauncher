//
//  TLSettings.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "TLSettings.h"

#define kExtensionKey       @"extension"
#define kActionKey          @"action"
#define kDefaultsStorageKey @"map"

@implementation TLSettings

- (void) setupInitialContent {
	NSArray *defaults = [[NSUserDefaults standardUserDefaults] arrayForKey:kDefaultsStorageKey];
	if (defaults) {
		[self addObjects:defaults];
	}
	else {
		[self addObject:@{kExtensionKey : @"txt",
						  kActionKey    : @"$EDITOR"}];
		[self addObject:@{kExtensionKey : @"log",
						  kActionKey    : @"$EDITOR"}];
	}
}

- (instancetype) initWithCoder:(NSCoder *)coder {
	if (self = [super initWithCoder:coder]) {
		[self setupInitialContent];
	}
	return self;
}

- (instancetype) init {
	if (self = [super init]) {
		[self setupInitialContent];
	}
	return self;
}

- (id) content {
	return [super content];
}

- (void) save {
	[[NSUserDefaults standardUserDefaults] setObject:self.content
											  forKey:kDefaultsStorageKey];
}

- (NSString *) actionForFileExtension:(NSString *)extension {
	return self.content[kActionKey];
}

@end
