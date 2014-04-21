//
//  MasterViewConroller.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "MasterViewController.h"

@interface MasterViewController ()

@end

@implementation MasterViewController
@synthesize connectionTimer,currentDisplay,socketConnection;

NSString* hostname = @"54.186.206.127";
int dataCnt;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code here.
        
        socketConnection = [[SocketIO alloc] initWithDelegate:self];
        [socketConnection connectToHost:hostname onPort:3333 withParams:nil withNamespace:@"/ios"];
        dataCnt = 0;
        
    }
    return self;
}

-(IBAction)sendEvent:(id)sender
{
    [self performSelectorOnMainThread:@selector(sendMessage) withObject:nil waitUntilDone:NO];
}

-(void)sendMessage
{
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
    };
    
    NSLog(@"Trying to Send");
    
    //if(socketConnection.isConnected)
    //{
        
        //        [_socketConnection sendMessage:@"TEMP SHIT"];
        [socketConnection sendMessage:[messageText stringValue] withAcknowledge:cb];
    //}
    //else{
    //    NSLog(@"Message Not Sent: NOT CONNECTED");
    //}
}


-(void)sendTestMessage
{
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
    };
    
    NSLog(@"Trying to Send");
    
    if(socketConnection.isConnected)
    {
        
        //        [_socketConnection sendMessage:@"TEMP SHIT"];
        [socketConnection sendMessage:@"TestMessage" withAcknowledge:cb];
    }
    else{
        NSLog(@"Message Not Sent: NOT CONNECTED");
    }
}


- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Socket has connected!");
}

- (void)socketIODidDisconnect:(SocketIO *)socket disconnectedWithError:(NSError *)error
{
    connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tryToReconnect) userInfo:nil repeats:YES];
}

- (void)tryToReconnect
{
    if(!socketConnection.isConnected)
    {
        NSLog(@"Trying to connect...");
        [socketConnection connectToHost:hostname onPort:3333 withParams:nil withNamespace:@"/ios"];
    }
    else
    {
        [connectionTimer invalidate];
        connectionTimer = nil;
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    // Grab the data from the packet.
    NSDictionary *dict = packet.dataAsJSON;
    
    // Pull out the arguments from the dictionary.
    NSArray *args = dict[@"args"];
    
    // Access the number object at index 0 of the "args" array.
    currentDisplay = args[0];
    
    NSLog(@"Recieved Data: %d", dataCnt);
    dataCnt++;
    
//    [self sendTestMessage];
    
    //    NSLog(@"%@", _currentDisplay);
}





@end
