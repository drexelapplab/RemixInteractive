//
//  AppDelegate.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/16/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

//@synthesize connectionTimer,currentDisplay,socketConnection;
@synthesize lightingPreview;
NSString* hostname = @"54.186.206.127";
int dataCnt;
int kPort = 4444;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
    

    [lightingPreview setupWithGridWidth:4 withGridHeight:4];
    
    _socketConnection = [[SocketIO alloc] initWithDelegate:self];
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tryToReconnect) userInfo:nil repeats:YES];
    
    dataCnt = 0;
    
}



-(void)sendMessage
{
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
    };
    
    NSLog(@"Trying to Send");
    
    if(_socketConnection.isConnected)
    {
    //        [_socketConnection sendMessage:@"TEMP SHIT"];
        [_socketConnection sendMessage:@"TEMP SHIT" withAcknowledge:cb];
    }
    else{
        NSLog(@"Message Not Sent: NOT CONNECTED");
    }
}

-(void)sendMessage:(NSString*)messageString
{
    SocketIOCallback cb = ^(id argsData) {
        NSDictionary *response = argsData;
        // do something with response
        NSLog(@"ack arrived: %@", response);
    };
    
    NSLog(@"Trying to Send");
    
    if(_socketConnection.isConnected)
    {
        //        [_socketConnection sendMessage:@"TEMP SHIT"];
        [_socketConnection sendMessage:messageString withAcknowledge:cb];
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
    _connectionTimer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(tryToReconnect) userInfo:nil repeats:YES];
}

- (void)tryToReconnect
{
    if(!_socketConnection.isConnected)
    {
        NSLog(@"Trying to connect...");
        [_socketConnection connectToHost:hostname onPort:kPort withParams:nil withNamespace:@"/ios"];
    }
    else
    {
        [_connectionTimer invalidate];
        _connectionTimer = nil;
    }
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    // Grab the data from the packet.
    NSDictionary *dict = packet.dataAsJSON;
    
    // Pull out the arguments from the dictionary.
    NSArray *args = dict[@"args"];
    
    NSString* messageStr = args[0];
    
    if(![messageStr isEqual:@""])
    {
        NSMutableArray* rgbValues = (NSMutableArray*)[messageStr componentsSeparatedByString:@"}{"];
        [rgbValues replaceObjectAtIndex:0 withObject:[[rgbValues objectAtIndex:0] substringFromIndex:1]];
        [rgbValues replaceObjectAtIndex:([rgbValues count]-1) withObject:[[rgbValues objectAtIndex:([rgbValues count]-1)] substringToIndex:( [[rgbValues objectAtIndex:([rgbValues count]-1)] length]-1 )]];
        
        
        for(int i=0;i<[rgbValues count];i++)
        {
            NSString* singleRGB = [rgbValues objectAtIndex:i];
            NSArray* colorVals = [singleRGB componentsSeparatedByString:@","];
            float r = [[colorVals objectAtIndex:0] floatValue];
            float g = [[colorVals objectAtIndex:1] floatValue];
            float b = [[colorVals objectAtIndex:2] floatValue];
            float a = [[colorVals objectAtIndex:3] floatValue];
            
            [lightingPreview sendColorToComponent:i withRed:r withGreen:g withBlue:b withAlpha:a];
        }
        
            
    }
    
    
    
    
    // Access the number object at index 0 of the "args" array.
    //_currentDisplay = args[0];
    
    
    
    NSLog(@"Recieved Data: %d", dataCnt);
    dataCnt++;
    
    //    NSLog(@"%@", _currentDisplay);
}



@end
