//
//  AppDelegate.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/7/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "AppDelegate.h"
#import "TLSettings.h"

@interface AppDelegate ()

@property (assign) IBOutlet NSWindow *window;
@end

@implementation AppDelegate {
	TLSettingsWindowController *settingsWindowController;
}

- (void) dealloc {
	[settingsWindowController release];
	[super dealloc];
}

- (void) settingsWindowDismissed:(TLSettingsWindowController *)controller {
	[NSApp terminate:self];
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
	settingsWindowController = [[TLSettingsWindowController alloc] initWithWindowNibName:@"TLSettingsWindowController"];
	settingsWindowController.delegate = self;
	[settingsWindowController.window makeKeyAndOrderFront:self];
}

- (BOOL)application:(NSApplication *)sender openFile:(NSString *)filename {
	/*
	 * If the application is launched as a result of opening a file, this
	 * method is called immedately, before applicationDidFinishLaunching.
	 *
	 * First we load up our settings. After that we execute the action mapped
	 * in the settings controller. Finally, we terminate ourself since we
	 * don't need to stick around.
	 */
	TLSettings *settings = [[TLSettings alloc] init];
	NSString *action = [settings actionForFileExtension:filename.pathExtension];

	if (action) {
		[AppDelegate openFile:filename withTerminalCommand:action];
	}
	else {
		NSAlert *alert = [[NSAlert alloc] init];

		alert.alertStyle = NSAlertStyleCritical;
		alert.messageText = @"No action assigned.";
		alert.informativeText = [NSString stringWithFormat:@"The file extension “%@” is associated with TLauncher, but does not have an action assigned to it. Please open TLauncher and set an action for this extension.", filename.pathExtension];

		[alert runModal];
		[alert release];
	}

	[settings release];

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
