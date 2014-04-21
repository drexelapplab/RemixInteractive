//
//  ViewController.h
//  Heartbeat
//
//  Created by Jordan Zagerman on 2/26/14.
//  Copyright (c) 2014 Jordan Zagerman. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SocketIO.h"
#import "LocateMeView.h"


@interface ViewController : UIViewController <SocketIODelegate>

@property (strong, nonatomic) SocketIO     *socketConnection;

@property (nonatomic) LocateMeView     *locateView;
@end