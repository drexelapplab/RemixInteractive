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
        pausedTime = 0.0;
        playingCues = NO;
        fileLoaded = NO;
    }
	return self;
}


#pragma mark -
#pragma mark Editing Custom Cue
#pragma mark -

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
        case 777:
            NSLog (@"Custom");
            r=[redBox floatValue]; g=[greenBox floatValue]; b=[blueBox floatValue],a=[alphaBox floatValue];
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

-(IBAction)editJumpToPreviousCue:(id)sender
{
    if(fileLoaded)
    {
        [editJumpToBox setIntValue:[editJumpToBox intValue]-1];
        
        if([editJumpToBox intValue]<1)
        {
            [editJumpToBox setIntValue:1];
            
        }
        
        [self presentEditCue:[editJumpToBox intValue]];
        
        
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }

    
}
-(IBAction)editJumpToDefinedCue:(id)sender
{
    if(fileLoaded)
    {
        [self presentEditCue:[editJumpToBox intValue]];
        
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }
}
-(IBAction)editJumpToNextCue:(id)sender
{
    if(fileLoaded)
    {
        [editJumpToBox setIntValue:[editJumpToBox intValue]+1];
        
        if([editJumpToBox intValue]>[lightingCues count])
        {
            [editJumpToBox setIntValue:(int)[lightingCues count]];
            
        }
        
        [self presentEditCue:[editJumpToBox intValue]];
        
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }

}
-(IBAction)editSaveCue:(id)sender
{
    
}
-(IBAction)editSaveCurrentCueList:(id)sender
{
    
}


-(void)presentEditCue:(int)index
{
    int tempIndex = index-1;
    if(tempIndex >=[lightingCues count])
        tempIndex = (int)[lightingCues count]-1;
    if(tempIndex<0)
        tempIndex = 0;
    LightingCue* tempCue = [lightingCues objectAtIndex:tempIndex];
    [frameNumBox setStringValue:tempCue.cueTagString];
    
    
    NSString* elapsedMinsStr;
    NSString* elapsedSecsStr;
    NSString* elapsedMSecsStr;
    
    if(tempCue.mins<9)
        elapsedMinsStr = [NSString stringWithFormat:@"0%d",tempCue.mins];
    else
        elapsedMinsStr = [NSString stringWithFormat:@"%d",tempCue.mins];
    
    if(tempCue.secs<9)
        elapsedSecsStr = [NSString stringWithFormat:@"0%d",tempCue.secs];
    else
        elapsedSecsStr = [NSString stringWithFormat:@"%d",tempCue.secs];
    
    if(tempCue.msecs<9)
        elapsedMSecsStr = [NSString stringWithFormat:@"00%d",tempCue.msecs];
    else if(tempCue.msecs<99)
        elapsedMSecsStr = [NSString stringWithFormat:@"0%d",tempCue.msecs];
    else
        elapsedMSecsStr = [NSString stringWithFormat:@"%d",tempCue.msecs];
    
    
    
    
    NSString* timeString = [NSString stringWithFormat:@"%@:%@:%@",elapsedMinsStr,elapsedSecsStr,elapsedMSecsStr];
    [editFrameTimeBox setStringValue:timeString];
    int colorCnt = 0;
    for(ShittyColor* sc in tempCue.rgbValues)
    {
        float r = sc.red;
        float g = sc.green;
        float b = sc.blue;
        float a = sc.alpha;
        
        [colorsView sendColorToComponent:colorCnt withRed:r withGreen:g withBlue:b withAlpha:a];
        colorCnt++;
    }
}




#pragma mark -
#pragma mark Sending Colors To Server
#pragma mark -
-(IBAction)sendStatic:(id)sender
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

-(IBAction)sendFlash:(id)sender{
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    ColorGridView* previousView = [[ColorGridView alloc] initWithColorGridView:d.lightingPreview];
    int count = 0;
    for(ColorView* cv in d.lightingPreview.viewList)
    {
        [previousView sendColorToComponent:count withRed:cv.color.redComponent withGreen:cv.color.greenComponent withBlue:cv.color.blueComponent withAlpha:cv.color.alphaComponent];
        count++;
    }
    
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
    [self performSelector:@selector(sendFullGrid:) withObject:previousView afterDelay:[flashTimeField intValue]/1000.0];
    
}

-(IBAction)sendOff:(id)sender{
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSString* fullColorsList = @"";
    for(ColorView* cv in colorsView.viewList)
    {
        float r = 0.0;
        float g = 0.0;
        float b = 0.0;
        float a = 1.0;
        NSString* jawnStr = [NSString stringWithFormat:@"{%f,%f,%f,%f}",r,g,b,a];
        fullColorsList = [fullColorsList stringByAppendingString:jawnStr];
    }
    NSLog(@"Sending: %@",fullColorsList);
    [d sendMessage:fullColorsList];
}


-(void)sendFullGrid:(ColorGridView*) gridToSend
{
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSString* fullColorsList = @"";
    for(ColorView* cv in gridToSend.viewList)
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


#pragma mark -
#pragma mark Navigating Pre-Defined Cues
#pragma mark -

-(IBAction)loadCueFile:(id)sender{
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    NSInteger clicked = [openDlg runModal];
    lightingCues = [[NSMutableArray alloc] init];
    if (clicked == NSFileHandlingPanelOKButton)
    {
        for (NSURL *url in [openDlg URLs])
        {
            // do something with the url here.
            NSString* filePath = [url relativePath];
            NSLog(@"AttemptingToLoad: %@",filePath);
            if([[NSFileManager defaultManager] isReadableFileAtPath:filePath])
            {
                NSData* data = [NSData dataWithContentsOfFile:filePath];
                //convert the bytes from the file into a string
                NSString* string = [[NSString alloc] initWithBytes:[data bytes] length:[data length] encoding:NSUTF8StringEncoding];
                
                //split the string around newline characters to create an array
                NSString* delimiter = @"\n";
                NSArray* allLinedStrings = [string componentsSeparatedByString:delimiter];
                
                
                for(NSString* str in allLinedStrings)
                {
                    LightingCue* tempCue = [[LightingCue alloc] initWithString:str];
                    [lightingCues addObject:tempCue];
                    
                }
                NSLog(@"DATA LOADED");
                [loadedFileBox setStringValue:filePath];
                currentCue = 0;
                [frameNumBox setIntValue:0];
                [frameTimeBox setStringValue:@"00:00:000"];
                [elapsedTimeBox setStringValue:@"00:00:000"];
                fileLoaded = YES;
                
            }
            else{
                NSLog(@"Data Not Loaded!!!! SHIT IS FUCKED!");
            }
        }
    }
}

-(IBAction)startCues:(id)sender{
    if(fileLoaded)
    {
        if(!playingCues)
        {
            playingCues = YES;
            cueTimer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(checkAndSendNextCue) userInfo:nil repeats:YES];
            cueTimerStart = [NSDate date];
            NSArray* timingsArray = [[elapsedTimeBox stringValue] componentsSeparatedByString:@":"];
            pausedTime = ([[timingsArray objectAtIndex:0] floatValue])*60.0
            +   ([[timingsArray objectAtIndex:1] floatValue])
            +   ([[timingsArray objectAtIndex:2] floatValue])/1000.0;
        }
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }
    
    
    
    // do stuff...
    
}
-(IBAction)pauseCues:(id)sender{
    //    NSTimeInterval timeInterval = [cueTimerStart timeIntervalSinceNow];
    //    pausedTime = timeInterval*-1 + pausedTime;
    [cueTimer invalidate];
    playingCues = NO;
}
-(IBAction)stopCues:(id)sender{
    [cueTimer invalidate];
    pausedTime = 0.0;
    [elapsedTimeBox setStringValue:@"00:00:000"];
    currentCue = 0;
    playingCues = NO;
}
-(IBAction)jumpToPreviousCue:(id)sender{
    
    if(fileLoaded)
    {
        [jumpToBox setIntValue:[jumpToBox intValue]-1];
        
        if([jumpToBox intValue]<1)
        {
            [jumpToBox setIntValue:1];
            
        }
        
        [self presentCue:[jumpToBox intValue]];
        
        
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }
    
    
}
-(IBAction)jumpToDefinedCue:(id)sender{
    if(fileLoaded)
    {
        [self presentCue:[jumpToBox intValue]];
        
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }
}

-(IBAction)jumpToNextCue:(id)sender{
    if(fileLoaded)
    {
        [jumpToBox setIntValue:[jumpToBox intValue]+1];
        
        if([jumpToBox intValue]>[lightingCues count])
        {
            [jumpToBox setIntValue:(int)[lightingCues count]];
            
        }
        
        [self presentCue:[jumpToBox intValue]];
        
    }
    else{
        NSAlert* msgBox = [[NSAlert alloc] init];
        [msgBox setMessageText: @"You must load a lighting cues file before you start."];
        [msgBox addButtonWithTitle: @"OK"];
        [msgBox runModal];
    }
    
}

-(void)presentCue:(int)index
{
    int tempIndex = index-1;
    if(tempIndex >=[lightingCues count])
        tempIndex = (int)[lightingCues count]-1;
    if(tempIndex<0)
        tempIndex = 0;
    LightingCue* tempCue = [lightingCues objectAtIndex:tempIndex];
    [frameNumBox setStringValue:tempCue.cueTagString];
    
    
    NSString* elapsedMinsStr;
    NSString* elapsedSecsStr;
    NSString* elapsedMSecsStr;
    
    if(tempCue.mins<9)
        elapsedMinsStr = [NSString stringWithFormat:@"0%d",tempCue.mins];
    else
        elapsedMinsStr = [NSString stringWithFormat:@"%d",tempCue.mins];
    
    if(tempCue.secs<9)
        elapsedSecsStr = [NSString stringWithFormat:@"0%d",tempCue.secs];
    else
        elapsedSecsStr = [NSString stringWithFormat:@"%d",tempCue.secs];
    
    if(tempCue.msecs<9)
        elapsedMSecsStr = [NSString stringWithFormat:@"00%d",tempCue.msecs];
    else if(tempCue.msecs<99)
        elapsedMSecsStr = [NSString stringWithFormat:@"0%d",tempCue.msecs];
    else
        elapsedMSecsStr = [NSString stringWithFormat:@"%d",tempCue.msecs];
    
    
    
    
    NSString* timeString = [NSString stringWithFormat:@"%@:%@:%@",elapsedMinsStr,elapsedSecsStr,elapsedMSecsStr];
    [frameTimeBox setStringValue:timeString];
    [elapsedTimeBox setStringValue:timeString];
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSString* fullColorsList = @"";
    for(ShittyColor* sc in tempCue.rgbValues)
    {
        float r = sc.red;
        float g = sc.green;
        float b = sc.blue;
        float a = sc.alpha;
        NSString* jawnStr = [NSString stringWithFormat:@"{%f,%f,%f,%f}",r,g,b,a];
        fullColorsList = [fullColorsList stringByAppendingString:jawnStr];
    }
    NSLog(@"Sending: %@",fullColorsList);
    [d sendMessage:fullColorsList];
    
}

-(void)checkAndSendNextCue
{
    NSLog(@"Checking and sending Cue");
    NSTimeInterval timeInterval = [cueTimerStart timeIntervalSinceNow];
    timeInterval = timeInterval*-1.0 + pausedTime;
    dispatch_async(dispatch_get_main_queue(), ^{
        
        int elapsedMins = timeInterval/60.0;
        int elapsedSecs = fmodf(timeInterval, 60);
        int elapsedMsecs = fmodf(timeInterval*1000.0, 1000);
        NSString* elapsedMinsStr;
        NSString* elapsedSecsStr;
        NSString* elapsedMSecsStr;
        
        if(elapsedMins<9)
            elapsedMinsStr = [NSString stringWithFormat:@"0%d",elapsedMins];
        else
            elapsedMinsStr = [NSString stringWithFormat:@"%d",elapsedMins];
        
        if(elapsedSecs<9)
            elapsedSecsStr = [NSString stringWithFormat:@"0%d",elapsedSecs];
        else
            elapsedSecsStr = [NSString stringWithFormat:@"%d",elapsedSecs];
        
        if(elapsedMsecs<9)
            elapsedMSecsStr = [NSString stringWithFormat:@"00%d",elapsedMsecs];
        else if(elapsedMsecs<99)
            elapsedMSecsStr = [NSString stringWithFormat:@"0%d",elapsedMsecs];
        else
            elapsedMSecsStr = [NSString stringWithFormat:@"%d",elapsedMsecs];
        
        [elapsedTimeBox setStringValue:[NSString stringWithFormat:@"%@:%@:%@",elapsedMinsStr,elapsedSecsStr,elapsedMSecsStr]];
        float nextCueTime = (float)((LightingCue*)[lightingCues objectAtIndex:currentCue]).mins*60.0
                            +   (float)((LightingCue*)[lightingCues objectAtIndex:currentCue]).secs
                            +   (float)((LightingCue*)[lightingCues objectAtIndex:currentCue]).msecs/1000.0;
        if(timeInterval>nextCueTime)
        {
            currentCue++;
            [self presentCue:currentCue];
        }
        
    });
    
}


#pragma mark -
#pragma mark Saving Shit: Defaults
#pragma mark -

-(IBAction)defaultsSaved:(id)sender{
    
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    // Restrict the file type to whatever you like
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"ri"]];
    // Set the starting directory
    [savePanel beginSheetModalForWindow:d.window completionHandler:^(NSInteger result){
        if (result == NSFileHandlingPanelOKButton) {
            // Close panel before handling errors
            [savePanel orderOut:self];
            NSURL* tempJawn = [savePanel URL];
            NSLog(@"Got Filepath: %@",[tempJawn path]);
            NSArray* components = [[tempJawn path] componentsSeparatedByString:@"/"];
            NSString* fullPath = @"";
            for (int i = 0;i<[components count]-1 ; i++)
            {
                fullPath = [NSString stringWithFormat:@"%@%@/",fullPath,[components objectAtIndex:i]];
                
            }
            NSLog(@"PATH:%@",fullPath);
            NSString* fileName = [[NSString alloc] initWithString:[components objectAtIndex:([components count]-1)]];
            NSLog(@"NAME: %@",fileName);
            
            // Save the array
            NSMutableArray *saveData = [self saveParameters];
            NSString *fullFileName = [tempJawn path];
            [NSKeyedArchiver archiveRootObject:saveData toFile:fullFileName];
            NSLog(@"Defaults Saved");
        }
    }];
}


-(IBAction)defaultsOpened:(id)sender{
    NSLog(@"Defaults Opened");
    // Create the File Open Dialog class.
    NSOpenPanel* openDlg = [NSOpenPanel openPanel];
    
    // Enable the selection of files in the dialog.
    [openDlg setCanChooseFiles:YES];
    
    // Enable the selection of directories in the dialog.
    [openDlg setCanChooseDirectories:YES];
    
    // Display the dialog.  If the OK button was pressed,
    // process the files.
    
    
    NSInteger clicked = [openDlg runModal];
    
    if (clicked == NSFileHandlingPanelOKButton) {
        for (NSURL *url in [openDlg URLs]) {
            // do something with the url here.
            NSString* filePath = [url absoluteString];
            NSLog(@"Loaded: %@",filePath);
            NSMutableArray *arrayFromDisk = [NSKeyedUnarchiver unarchiveObjectWithFile:filePath];
            [self editAllParameters:arrayFromDisk];
        }
    }
}


-(void)editAllParameters:(NSMutableArray*)params
{
//    [chromaSliderJawn       setFloatValue:[[params objectAtIndex:0]  floatValue]];
//    [sendGainSliderJawn     setFloatValue:[[params objectAtIndex:1]  floatValue]];
//    [openGLGainSlider       setFloatValue:[[params objectAtIndex:2]  floatValue]];
//    [soundFieldGain         setFloatValue:[[params objectAtIndex:3]  floatValue]];
//    [soundFieldOffset       setFloatValue:[[params objectAtIndex:4]  floatValue]];
    
}


-(NSMutableArray*)saveParameters
{
    NSMutableArray* params = [[NSMutableArray alloc] init];
    
//    [params addObject:[NSNumber numberWithFloat:[chromaSliderJawn       floatValue]]];
//    [params addObject:[NSNumber numberWithFloat:[sendGainSliderJawn     floatValue]]];
//    [params addObject:[NSNumber numberWithFloat:[openGLGainSlider       floatValue]]];
//    [params addObject:[NSNumber numberWithFloat:[soundFieldGain         floatValue]]];
//    [params addObject:[NSNumber numberWithFloat:[soundFieldOffset       floatValue]]];

    
    return params;
    
}





@end
