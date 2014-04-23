//
//  AppDelegate.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/16/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SocketIO.h"
#import "MasterViewController.h"
#import "ColorGridView.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    
}


-(void)sendMessage:(NSString*)messageString;

@property (strong, nonatomic) SocketIO *socketConnection;
@property (strong, nonatomic) NSTimer *connectionTimer;
@property (nonatomic)         NSArray* currentDisplay;
@property (strong, nonatomic) IBOutlet ColorGridView* lightingPreview;
//@property (nonatomic,strong) IBOutlet MasterViewController *masterViewController;
@property (assign) IBOutlet NSWindow *window;


@end
