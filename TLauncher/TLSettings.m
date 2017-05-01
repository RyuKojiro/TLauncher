//
//  TLSettings.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "TLSettings.h"
#import <CoreServices/CoreServices.h>

#define kExtensionKey       @"extension"
#define kActionKey          @"action"
#define kDefaultsStorageKey @"map"
#define kTLauncherHandlerId @"org.loffgren.tlauncher"

@implementation NSArray (TLSettingsHelper)

- (NSDictionary *) dictionaryForExtension:(NSString *)extension {
	__block id result = nil;

	[self enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
		if ([obj[kExtensionKey] isEqualToString:extension]) {
			*stop = YES;
			result = obj;
		}
	}];

	return result;
}

@end

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

- (void) save {
	NSArray *defaults = [[NSUserDefaults standardUserDefaults] arrayForKey:kDefaultsStorageKey];

	/*
	 * There are only three cases of concern here: addition, removal, and
	 * modification. The first two are simple, and are handled individually by
	 * the two for-in blocks that follow. The modification case is handled by
	 * the fact that it will appear to the comparison logic below as both a
	 * removal of the old behavior and an addition of the new behavior.
	 */

	// First unassign any associations that were removed
	for (NSDictionary *def in defaults) {
		NSString *extension = def[kExtensionKey];
		NSDictionary *con = [self.content dictionaryForExtension:extension];

		if (![def[kActionKey] isEqualToString:con[kActionKey]]) {
			/*
			 * This section unregisters TLauncher from the list of handlers
			 * for the given type. This is done by getting the list, verifying
			 * that TLauncher is the default, and if so, promoting the second
			 * application to the default. If there is no second item, we just
			 * bail and stay associated. TLauncher can also be the default
			 * but not be in the list of handlers. In this case, if there is
			 * at least a single handler, make the first one the new default.
			 *
			 * The behavior for determining what application to run for any
			 * given UTI is documented here:
			 * https://developer.apple.com/library/content/documentation/Carbon/Conceptual/LaunchServicesConcepts/LSCConcepts/LSCConcepts.html#//apple_ref/doc/uid/TP30000999-CH202-SW21
			 */
			CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)extension, NULL);
			NSArray *handlers = (NSArray *)LSCopyAllRoleHandlersForContentType(uti, kLSRolesAll);

			if ([[handlers firstObject] isEqualToString:kTLauncherHandlerId]) {
				if (handlers.count > 1) {
					LSSetDefaultRoleHandlerForContentType(uti, kLSRolesViewer, (CFStringRef)handlers[1]);
				}
			}
			else if (handlers.count > 0) {
				LSSetDefaultRoleHandlerForContentType(uti, kLSRolesViewer, (CFStringRef)handlers[0]);
			}
		}
	}

	// Now add any new associations
	for (NSDictionary *con in self.content) {
		NSString *extension = con[kExtensionKey];
		NSDictionary *def = [defaults dictionaryForExtension:extension];

		if (![def[kActionKey] isEqualToString:con[kActionKey]]) {
			CFStringRef uti = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, (CFStringRef)con[kExtensionKey], NULL);
			LSSetDefaultRoleHandlerForContentType(uti, kLSRolesViewer, (CFStringRef)kTLauncherHandlerId);
		}
	}

	// Finally commit the save
	[[NSUserDefaults standardUserDefaults] setObject:self.content
											  forKey:kDefaultsStorageKey];
}

- (NSString *) actionForFileExtension:(NSString *)extension {
	for (NSDictionary *d in self.content) {
		if ([d[kExtensionKey] isEqualToString:extension]) {
			return d[kActionKey];
		}
	}
	return nil;
}

@end
