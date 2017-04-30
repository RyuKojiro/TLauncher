//
//  AppDelegate.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/7/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "AppDelegate.h"
#import "TLSettingsWindowController.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@end

@implementation AppDelegate {
	TLSettingsWindowController *settings;
}

- (void) dealloc {
	[settings release];
	[super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	/*
	 * If the application is NOT launched as a result of opening a file, this
	 * method is called and applicationDidFinishLaunching is not.
	 *
	 * Because we are being launched for settings customization, first become
	 * a UI application, to be much friendlier to the user.
	 */
	ProcessSerialNumber psn = { 0, kCurrentProcess };
	TransformProcessType(&psn, kProcessTransformToForegroundApplication);
	[NSApp activateIgnoringOtherApps:YES];

	// Now show the settings window
	settings = [[TLSettingsWindowController alloc] initWithWindowNibName:@"TLSettingsWindowController"];
	[settings.window makeKeyAndOrderFront:self];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
	/*
	 * If the application is launched as a result of opening a file, this
	 * method is called immedately, before applicationDidFinishLaunching.
	 */
	[AppDelegate openFile:filename withTerminalCommand:@"$EDITOR"];
	[NSApp terminate:self];
	return YES;
}

+ (void) activateTerminal {
	NSRunningApplication *terminal = [[NSRunningApplication runningApplicationsWithBundleIdentifier:@"com.apple.Terminal"] firstObject];
	[terminal activateWithOptions:NSApplicationActivateIgnoringOtherApps];
}

+ (void) openFile:(NSString *)fileName withTerminalCommand:(NSString *)command {
	NSString *source = [NSString stringWithFormat:@"tell application \"Terminal\" to do script \"%@ \'%@\' && exit\"", command, fileName];

	NSAppleScript *appleScript = [[NSAppleScript alloc] initWithSource:source];
	[appleScript executeAndReturnError:nil];
	[appleScript release];

	[self activateTerminal];
}

@end
