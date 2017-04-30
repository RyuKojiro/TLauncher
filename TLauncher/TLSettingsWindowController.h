//
//  TLSettingsWindowController.h
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TLSettings.h"

@class TLSettingsWindowController;

@protocol TLSettingsWindowDelegate <NSObject>
- (void) settingsWindowDismissed:(TLSettingsWindowController *)controller;
@end

@interface TLSettingsWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>

@property (assign) IBOutlet TLSettings *settings;
@property (assign) IBOutlet NSTableView *tableView;

@property (assign) id <TLSettingsWindowDelegate> delegate;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)add:(id)sender;

@end
