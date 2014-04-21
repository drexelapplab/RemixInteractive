//
//  InterfaceControl.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "InterfaceControl.h"
#import "AppDelegate.h"
@implementation InterfaceControl
int cnt;
-(id)init
{
	self = [super init];
	if( self )
	{
        cnt = 0;
    }
	return self;
}

-(IBAction)initControl:(id)sender
{
    [colorsView setupWithGridWidth:4 withGridHeight:4];
}

-(IBAction)selectAll:(id)sender
{
    for(int i = 0; i<[colorsView.viewList count];i++)
    {
        [((ColorView*)[colorsView.viewList objectAtIndex:i]) setIsSelected:YES];
        [((ColorView*)[colorsView.viewList objectAtIndex:i]) setNeedsDisplay:YES];
    }
}

-(IBAction)selectNone:(id)sender
{
    for(int i = 0; i<[colorsView.viewList count];i++)
    {
        [((ColorView*)[colorsView.viewList objectAtIndex:i]) setIsSelected:NO];
        [((ColorView*)[colorsView.viewList objectAtIndex:i]) setNeedsDisplay:YES];
    }
}


-(IBAction)sendColor:(id)sender
{
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    float r = 0;
    float g = 0;
    float b = 0;
    float a = 1;
    
    switch(((NSButton*)sender).tag)
    {
        case 0:
            NSLog (@"Black");
            r=0.0; g=0.0; b=0.0;
            break;
        case 555:
            NSLog (@"Gray");
            r=0.5; g=0.5; b=0.5;
            break;
        case 111:
            NSLog (@"White");
            r=1; g=1; b=1;
            break;
        case 100:
            NSLog (@"Red");
            r=1.0; g=0.0; b=0.0;
            break;
        case 110:
            NSLog (@"Yellow");
            r=1.0; g=1.0; b=0.0;
            break;
        case 10:
            NSLog (@"Green");
            r=0.0; g=1.0; b=0.0;
            break;
        case 11:
            NSLog (@"Cyan");
            r=0.0; g=1.0; b=1.0;
            break;
        case 1:
            NSLog (@"Blue");
            r=0.0; g=0.0; b=1.0;
            break;
        case 101:
            NSLog (@"Magenta");
            r=1.0; g=0.0; b=1.0;
            break;
        case 550:
            NSLog (@"Orange");
            r=1.0; g=0.5; b=0.0;
            break;
        case 505:
            NSLog (@"Purple");
            r=0.5; g=0.0; b=1.0;
            break;
        default:
            break;

    }
    for(int i = 0; i<[colorsView.viewList count];i++)
    {
        if(((ColorView*)[colorsView.viewList objectAtIndex:i]).isSelected)
        {
            [((ColorView*)[colorsView.viewList objectAtIndex:i]) setIsSelected:NO];
            [colorsView sendColorToComponent:i withRed:r withGreen:g withBlue:b withAlpha:a];
            
        }
    }
}


-(IBAction)sendEvent:(id)sender
{
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSString* fullColorsList = @"";
    for(ColorView* cv in colorsView.viewList)
    {
        float r = cv.color.redComponent;
        float g = cv.color.greenComponent;
        float b = cv.color.blueComponent;
        float a = cv.color.alphaComponent;
        NSString* jawnStr = [NSString stringWithFormat:@"{%f,%f,%f,%f}",r,g,b,a];
        fullColorsList = [fullColorsList stringByAppendingString:jawnStr];
    }
    NSLog(@"Sending: %@",fullColorsList);
    [d sendMessage:fullColorsList];
    
}

@end
