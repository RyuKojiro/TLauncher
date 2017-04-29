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
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
}

- (IBAction)add:(id)sender {

}

- (IBAction)remove:(id)sender {

}

- (IBAction)save:(id)sender {
	[self.window orderOut:sender];
}

- (IBAction)cancel:(id)sender {
	[self.window orderOut:sender];
}

@end
