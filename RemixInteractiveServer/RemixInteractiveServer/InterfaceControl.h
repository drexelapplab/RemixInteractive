//
//  InterfaceControl.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "ColorGridView.h"

@interface InterfaceControl : NSObject
{
    IBOutlet NSTextField* messageText;
    AppDelegate* delegate;
    IBOutlet ColorGridView* colorsView;
    
    
}
-(IBAction)initControl:(id)sender;
-(IBAction)selectAll:(id)sender;
-(IBAction)selectNone:(id)sender;
-(IBAction)sendEvent:(id)sender;
-(IBAction)sendColor:(id)sender;



@end
