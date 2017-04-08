//
//  AppDelegate.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/7/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@end

@implementation AppDelegate {
	BOOL launchedByOwnVolition;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	// This relies on the fact that it always happens after the open if the open caused the launch
	launchedByOwnVolition = YES;
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
	// Insert code here to tear down your application
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
	[AppDelegate openFile:filename withTerminalCommand:@"$EDITOR"];
	if (!launchedByOwnVolition) {
		[NSApp terminate:self];
	}
	return YES;
}

+ (void) openFile:(NSString *)fileName withTerminalCommand:(NSString *)command {
	NSString *source = [NSString stringWithFormat:@"tell application \"Terminal\" to do script \"%@ %@ && exit\"", command, fileName];

	NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:source];
	[appleScript executeAndReturnError:nil];
	[appleScript release];
}

@end
