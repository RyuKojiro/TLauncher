//
//  TLSettingsWindowController.h
//  TLauncher
//
//  Created by Daniel Loffgren on 4/29/17.
//  Copyright © 2017 Daniel Loffgren. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "TLSettings.h"

@interface TLSettingsWindowController : NSWindowController <NSTableViewDelegate, NSTableViewDataSource>

@property (assign) IBOutlet TLSettings *settings;
@property (assign) IBOutlet NSTableView *tableView;

- (IBAction)save:(id)sender;
- (IBAction)cancel:(id)sender;

- (IBAction)add:(id)sender;

@end
