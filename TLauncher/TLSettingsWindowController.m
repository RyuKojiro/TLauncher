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
	[self.window orderOut:sender];
}

- (IBAction)cancel:(id)sender {
	[self.window orderOut:sender];
}

@end
