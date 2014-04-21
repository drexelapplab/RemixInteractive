//
//  ViewController.m
//  Heartbeat
//
//  Created by Jordan Zagerman on 2/26/14.
//  Copyright (c) 2014 Jordan Zagerman. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController
@synthesize locateView;
int receivedPackets;
- (void)viewDidLoad
{
    [super viewDidLoad];
    receivedPackets = 0;
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    [[UIScreen mainScreen]setBrightness:1.0];
    
    _socketConnection = [[SocketIO alloc] initWithDelegate:self];
    
    [_socketConnection connectToHost:@"54.186.206.127" onPort:3333 withParams:nil withNamespace:@"/ios"];
    
    CGRect frame = CGRectMake(0,0,self.view.frame.size.height,self.view.frame.size.width);
    locateView = [[LocateMeView alloc] initWithFrame:frame];
    [locateView setBackgroundColor:[UIColor whiteColor]];
    locateView.hidden = NO;
    
    UIImageView* iv = [[UIImageView alloc] initWithFrame:frame];
    
    if(frame.size.width==568)
    {
        [iv setImage:[UIImage imageNamed:@"locateImage.png"]];
    }
    else{
        [iv setImage:[UIImage imageNamed:@"locateImage4.png"]];
    }
    
    [locateView addSubview:iv];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [button addTarget:self action:@selector(showPickerView:) forControlEvents:UIControlEventTouchUpInside];
    //[button setTitle:@"Locate" forState:UIControlStateNormal];
    [button setBackgroundImage:[UIImage imageNamed:@"locate.png"] forState:UIControlStateNormal];
    button.frame = CGRectMake(self.view.frame.size.height-60, self.view.frame.size.width-60, 50, 50);
    [self.view addSubview:button];
    [self.view addSubview:locateView];
    
    
    
    
}

//the next thing is to add it as a subview to the ViewController's self.view
//

-(IBAction)showPickerView:(id)sender{
    locateView.hidden = NO;
}

- (void)socketIODidConnect:(SocketIO *)socket
{
    NSLog(@"Socket has connected!");
}

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    
    // Grab the data from the packet.
    NSDictionary *dict = packet.dataAsJSON;
    
    // Pull out the arguments from the dictionary.
    NSArray *args = dict[@"args"];
    
    // Access the number object at index 0 of the "args" array.

    //NSArray *numbers = args[0];
    
    int number = locateView.currentPositionIndex;
    
    NSString* messageStr = args[0];
    
    NSMutableArray* rgbValues = (NSMutableArray*)[messageStr componentsSeparatedByString:@"}{"];
    [rgbValues replaceObjectAtIndex:0 withObject:[[rgbValues objectAtIndex:0] substringFromIndex:1]];
    [rgbValues replaceObjectAtIndex:([rgbValues count]-1) withObject:[[rgbValues objectAtIndex:([rgbValues count]-1)] substringToIndex:( [[rgbValues objectAtIndex:([rgbValues count]-1)] length]-1 )]];
    
    NSString* singleRGB = [rgbValues objectAtIndex:number];
    
    // Change the background color with the message's number as input.
    NSArray* colorArray = [singleRGB componentsSeparatedByString:@","];
    float r = [[colorArray objectAtIndex:0] floatValue];
    float g = [[colorArray objectAtIndex:1] floatValue];
    float b = [[colorArray objectAtIndex:2] floatValue];
    float a = [[colorArray objectAtIndex:3] floatValue];
    
    UIColor* c = [UIColor colorWithRed:r green:g blue:b alpha:a];
    
    self.view.backgroundColor = c;
    
    if(fmodf((float)receivedPackets,50.0)==0)
    {
        NSLog(@"Rec:%d \tPosition:%d, Red:%f \tGreen:%f \tBlue:%f \tAlpha:%f",receivedPackets, number,r,g,b,a);
            
    }
    receivedPackets++;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.

}




@end

