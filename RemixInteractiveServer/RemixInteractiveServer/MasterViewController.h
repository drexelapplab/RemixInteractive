//
//  MasterViewConroller.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SocketIO.h"

@interface MasterViewController : NSViewController <SocketIODelegate>
{
    IBOutlet NSTextField* messageText;
}

-(IBAction)sendEvent:(id)sender;

@property (strong, nonatomic) SocketIO *socketConnection;
@property (strong, nonatomic) NSTimer *connectionTimer;
@property (nonatomic)         NSArray* currentDisplay;

@end
