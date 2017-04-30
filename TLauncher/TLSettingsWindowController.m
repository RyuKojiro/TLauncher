//
//  TLSettingsWindowController.m
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import "TLSettingsWindowController.h"

@interface TLSettingsWindowController ()

@end

@implementation TLSettingsWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
}

- (IBAction)save:(id)sender {
	[self.settings save];
	[self.window orderOut:sender];
}

- (IBAction)cancel:(id)sender {
	[self.window orderOut:sender];
}

- (IBAction)add:(id)sender {
	[_settings addObject:_settings.newObject];
	[_settings rearrangeObjects];

	NSUInteger row = [_settings.arrangedObjects count] - 1;
	NSIndexSet *set = [NSIndexSet indexSetWithIndex:row];
	[_tableView selectRowIndexes:set byExtendingSelection:NO];
	[_tableView editColumn:0
					   row:row
				 withEvent:nil
					select:YES];
}

@end
