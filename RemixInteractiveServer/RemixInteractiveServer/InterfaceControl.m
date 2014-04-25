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
    //EDIT The cue in the list.
    //Update the current file.
    int currentEditCue = [editJumpToBox intValue];
    NSString* timeCodeStr = [editFrameTimeBox stringValue];
    NSString* cueString = @"";
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
    
    cueString = [NSString stringWithFormat:@"%d|%@|%@",currentEditCue,timeCodeStr,fullColorsList];
    
    LightingCue* tempCue = [[LightingCue alloc] initWithString:cueString];
    [lightingCues replaceObjectAtIndex:(currentEditCue-1) withObject:tempCue];
    
    
    
    
}
-(IBAction)editSaveCurrentCueList:(id)sender
{
    // Save the current cues list to a text file.
    
    //EDIT The cue in the list.
    //Update the current file.
    
    NSString* fullCuesString = @"";
    
    for(int i = 0; i<[lightingCues count];i++)
    {
        int currentEditCue = i+1;

        NSString* elapsedMinsStr;
        NSString* elapsedSecsStr;
        NSString* elapsedMSecsStr;
        
        if(((LightingCue*)[lightingCues objectAtIndex:i]).mins<9)
            elapsedMinsStr = [NSString stringWithFormat:@"0%d",((LightingCue*)[lightingCues objectAtIndex:i]).mins];
        else
            elapsedMinsStr = [NSString stringWithFormat:@"%d",((LightingCue*)[lightingCues objectAtIndex:i]).mins];
        
        if(((LightingCue*)[lightingCues objectAtIndex:i]).secs<9)
            elapsedSecsStr = [NSString stringWithFormat:@"0%d",((LightingCue*)[lightingCues objectAtIndex:i]).secs];
        else
            elapsedSecsStr = [NSString stringWithFormat:@"%d",((LightingCue*)[lightingCues objectAtIndex:i]).secs];
        
        if(((LightingCue*)[lightingCues objectAtIndex:i]).msecs<9)
            elapsedMSecsStr = [NSString stringWithFormat:@"00%d",((LightingCue*)[lightingCues objectAtIndex:i]).msecs];
        else if(((LightingCue*)[lightingCues objectAtIndex:i]).msecs<99)
            elapsedMSecsStr = [NSString stringWithFormat:@"0%d",((LightingCue*)[lightingCues objectAtIndex:i]).msecs];
        else
            elapsedMSecsStr = [NSString stringWithFormat:@"%d",((LightingCue*)[lightingCues objectAtIndex:i]).msecs];
        
        NSString* timeCodeStr = [NSString stringWithFormat:@"%@:%@:%@",elapsedMinsStr,elapsedSecsStr,elapsedMSecsStr];
        
        NSString* cueString = @"";
        NSString* fullColorsList = @"";
        
        
        for(ShittyColor* sc in ((LightingCue*)[lightingCues objectAtIndex:i]).rgbValues)
        {
            float r = sc.red;
            float g = sc.green;
            float b = sc.blue;
            float a = sc.alpha;
            NSString* jawnStr = [NSString stringWithFormat:@"{%f,%f,%f,%f}",r,g,b,a];
            fullColorsList = [fullColorsList stringByAppendingString:jawnStr];
        }
        
        cueString = [NSString stringWithFormat:@"%d|%@|%@\n",currentEditCue,timeCodeStr,fullColorsList];
        fullCuesString = [fullCuesString stringByAppendingString:cueString];
    }
    
    AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
    NSSavePanel * savePanel = [NSSavePanel savePanel];
    // Restrict the file type to whatever you like
    [savePanel setAllowedFileTypes:[NSArray arrayWithObject:@"riQ"]];
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
            
            NSString* fullFilePath = [NSString stringWithFormat:@"%@%@",fullPath,fileName];
            // Save the array
            NSError *error = nil;
            [fullCuesString writeToFile:fullFilePath atomically:YES encoding:NSUTF8StringEncoding error:&error];
            NSLog(@"Was there an Error: %@", error.localizedFailureReason);
        }
    }];

    
    
    
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
                    if(![str isEqualToString:@""])
                    {
                        LightingCue* tempCue = [[LightingCue alloc] initWithString:str];
                        [lightingCues addObject:tempCue];
                    }
                    
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
    if(tempIndex >=([lightingCues count]-1))
        //tempIndex= ([lightingCues count]-2);
        tempIndex = 0;
    if(tempIndex<0)
        tempIndex = 0;
    
    
    currentCue = tempIndex+1;
    
    
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

-(void)jumpToNextCueManual{
    if(fileLoaded)
    {
        [jumpToBox setIntValue:[jumpToBox intValue]+1];
        
        if([jumpToBox intValue]>[lightingCues count])
        {
            [jumpToBox setIntValue:(int)[lightingCues count]];
            
        }
        
        [self presentCue:[jumpToBox intValue]];
        
    }
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
        
        
        if(currentCue<[lightingCues count])
        {
            
            [elapsedTimeBox setStringValue:[NSString stringWithFormat:@"%@:%@:%@",elapsedMinsStr,elapsedSecsStr,elapsedMSecsStr]];
            float nextCueTime = (float)((LightingCue*)[lightingCues objectAtIndex:currentCue]).mins*60.0
            +   (float)((LightingCue*)[lightingCues objectAtIndex:currentCue]).secs
            +   (float)((LightingCue*)[lightingCues objectAtIndex:currentCue]).msecs/1000.0;
            if(timeInterval>nextCueTime)
            {
                currentCue++;
                [self presentCue:currentCue];
            }
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
-(IBAction)initAudio:(id)sender{
    [self initAudioShit];
}


#pragma mark -
#pragma mark Audio Shit
#pragma mark -


//AudioShit
-(void) initAudioShit
{
    cycle = 0 ;
	level1 = level2 = 0 ;
	manager = [ [ AFManager alloc ] init ] ;
	
//	outputSoundcard = [ manager newOutputSoundcard ] ;
//	[ outputSoundcard setResamplingRate:48000.0 ] ;
//	[ outputSoundcard setBufferLength:512 ] ;
    
	inputSoundcard = [ manager newInputSoundcard ] ;
	[ inputSoundcard setResamplingRate:44100 ] ;
	[ inputSoundcard setBufferLength:512 ] ;
	
	//	Let the input AFSoundcard manage the volume sliders
//	[ inputSoundcard setManagedVolumeSlider:volumeSlider0 channel:0 ] ;
	[ inputSoundcard setManagedVolumeSlider:volumeSlider1 channel:1 ] ;
	[ inputSoundcard setManagedVolumeSlider:volumeSlider2 channel:2 ] ;
	[ inputSoundcard setDelegate:self ] ;
	
	//	start sampling
//	[ outputSoundcard start ] ;
	[ inputSoundcard start ] ;
    prevJawnFlash = NO;
    movingMax = 0;
    movingMin = 0;
}

- (void)updateVUMeter:(NSLevelIndicator*)indicator buffer:(float*)buffer samples:(int)samples
{
	float max, v ;
	int i ;
    
	max = 0 ;
	for ( i = 0; i < samples; i++ ) {
		v = fabs( buffer[i] ) ;
		if ( v > max ) max = v ;
	}
	if ( indicator == levelIndicator1 ) level1 = v = level1*0.75 + max*0.25 ; else level2 = v = level2*0.75 + max*0.25 ;
	if ( cycle == 0 ) [ indicator setFloatValue:v*100 ] ;
}


- (void)setRMSMeter:(float)rms
{
    float mAvgTail = [rmsTail floatValue];
    float displayRMS = powf(rms,[rmsPower floatValue])*powf(10, [rmsScale floatValue]/20);
    prevDisplayRMS = (prevDisplayRMS*((mAvgTail-1)/mAvgTail) + displayRMS*(1.0/mAvgTail));
	[avgRMSIndicator setFloatValue:prevDisplayRMS];
    [self doSomethingWithRMS:prevDisplayRMS];
}
-(void) doSomethingWithRMS:(float)rmsJawn
{
    
    
    if(checkBoxRMS.state==NSOnState)
    {
       if(rmsJawn>50 && !prevJawnFlash)
        {
            [self jumpToNextCueManual];
            prevJawnFlash = YES;
        }
        
        if(rmsJawn<50)
        {
            prevJawnFlash = NO;
            
        }

    }
    if(checkBoxRMSFlash.state==NSOnState)
    {
        AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
        NSString* fullColorsList = @"";
        
        float alphaScale =rmsJawn/100.0;
        for(int i = 0; i<16; i++)
        {
            float r = 1.0;
            float g = 1.0;
            float b = 1.0;
            float a = alphaScale;
            NSString* jawnStr = [NSString stringWithFormat:@"{%f,%f,%f,%f}",r,g,b,a];
            fullColorsList = [fullColorsList stringByAppendingString:jawnStr];
        }
        NSLog(@"Sending: %@",fullColorsList);
        [d sendMessage:fullColorsList];
        
    }

    
}

- (void)setFFTMeter:(float*)fft withSize:(int) fftSize
{
    fftSize = fftSize/2;
    float meters[4] = {0,0,0,0};
    for(int i = 0;i<fftSize;i++)
    {
        fft[i] = 10*log10f(fft[i]); //dB
        if(i<fftSize*0.125)
        {
            meters[0]+=fft[i]*(1.0/(fftSize*0.125));
        }
        else if(i<fftSize*0.25)
        {
            meters[1]+=fft[i]*(1.0/(fftSize*0.125));
        }
        else if(i<fftSize*0.5)
        {
            meters[2]+=fft[i]*(1.0/(fftSize*0.25));
        }
        else
        {
            meters[3]+=fft[i]*(1.0/(fftSize*0.5));
        }
//        NSLog(@"I: %d   FFT:%f",i,fft[i]);
        
    }
    
    
    float min = 1000000.0;
    for(int i = 0; i<4;i++)
    {
        if(meters[i]<min)
            min = meters[i];
    }
    for(int i = 0; i<4;i++)
    {
        meters[i]-=movingMin;
    }
    movingMin = movingMin*(.9) + min*(.1);
    
    
    float max = -1000000.0;
    for(int i = 0; i<4;i++)
    {
        if(meters[i]>max)
            max = meters[i];
    }
    movingMax = movingMax*(.9) + max*(.1);
    
    for(int i = 0; i<4;i++)
    {
        meters[i]/=movingMax;
    }
    
    [levelIndicatorFFT1 setIntValue:meters[0]*4];
    [levelIndicatorFFT2 setIntValue:meters[1]*4];
    [levelIndicatorFFT3 setIntValue:meters[2]*4];
    [levelIndicatorFFT4 setIntValue:meters[3]*4];
    
    [self doSomethingWithFFT:meters];
}

-(void) doSomethingWithFFT:(float[])meters
{
    if(checkBoxFFT.state == NSOnState)
    {
        AppDelegate* d = (AppDelegate *) [[NSApplication sharedApplication] delegate];
        NSString* fullColorsList = @"";
        for(int i = 0; i<16;i++)
        {
            int meterIndex = fmodf(i, 4);
            
            float r = 0.0;
            float g = 0.0;
            float b = 0.0;
            float a = 1.0;
            
            if(i<4)
            {
                if(meters[meterIndex]>=1)
                {
                    r = 1.0;
                    g = 0.0;
                    b = 0.0;
                    a = 1.0;
                }
            }
            else if(i<8)
            {
                if(meters[meterIndex]>=0.75)
                {
                    r = 1.0;
                    g = 1.0;
                    b = 0.0;
                    a = 1.0;
                }
                
            }
            else if(i<12)
            {
                if(meters[meterIndex]>=0.5)
                {
                    r = 0.0;
                    g = 1.0;
                    b = 0.0;
                    a = 1.0;
                }
            }
            else
            {
                if(meters[meterIndex]>=0.25)
                {
                    r = 0.0;
                    g = 1.0;
                    b = 0.0;
                    a = 1.0;
                }
                
            }
            
            
            
            
            NSString* jawnStr = [NSString stringWithFormat:@"{%f,%f,%f,%f}",r,g,b,a];
            fullColorsList = [fullColorsList stringByAppendingString:jawnStr];
        }
        NSLog(@"Sending: %@",fullColorsList);
        [d sendMessage:fullColorsList];
    }
}

- (void)zeroVUMeter:(NSLevelIndicator*)indicator
{
	[ indicator setFloatValue:0 ] ;
	if ( indicator == levelIndicator1 ) level1 = 0 ; else level2 = 0 ;
}

- (void)inputReceivedFromSoundcard:(AFSoundcard*)soundcard buffers:(float**)buffers numberOfBuffers:(int)n samples:(int)samples
{
//	[ outputSoundcard pushBuffers:buffers numberOfBuffers:n samples:samples rateScalar:[ soundcard rateScalar ] ] ;
	
    
	SimpleFFT* fftJawn = [[SimpleFFT alloc] init];
    [fftJawn fftSetSize:512];
    
	if ( n > 1 )
    {
        [ self updateVUMeter:levelIndicator1 buffer:buffers[0] samples:samples ];
        [ self updateVUMeter:levelIndicator2 buffer:buffers[1] samples:samples ];
        float avgRMS = ([self calculateRMS:buffers[0] samples:samples] + [self calculateRMS:buffers[1] samples:samples])/2.0;
        [self setRMSMeter:avgRMS];
        
        float* singleChannel = (float*)calloc(samples, sizeof(float));
        float* singleChannelFFT = (float*)calloc(samples, sizeof(float));
        float* trashPhase = (float*)calloc(samples, sizeof(float));
        [self convertToMono:buffers numberOfBuffers:n samples:samples outBuffer:singleChannel];
        [fftJawn forwardWithStart:0 withBuffer:singleChannel magnitude:singleChannelFFT phase:trashPhase useWinsow:YES];
        [self setFFTMeter:singleChannelFFT  withSize:samples];
        free(trashPhase);
        
	}
    else if ( n > 0 )
    {
        [ self updateVUMeter:levelIndicator1 buffer:buffers[0] samples:samples ];
        [ self zeroVUMeter:levelIndicator2 ];
        float avgRMS = [self calculateRMS:buffers[0] samples:samples];
        [self setRMSMeter:avgRMS];
        
        float* singleChannelFFT = (float*)calloc(samples, sizeof(float));
        float* trashPhase = (float*)calloc(samples, sizeof(float));
        [self convertToMono:buffers numberOfBuffers:n samples:samples outBuffer:buffers[0]];
        [fftJawn forwardWithStart:0 withBuffer:buffers[0] magnitude:singleChannelFFT phase:trashPhase useWinsow:YES];
        [self setFFTMeter:singleChannelFFT withSize:samples];
        free(trashPhase);
    }
    else
    {
        [ self zeroVUMeter:levelIndicator1 ];
        [ self zeroVUMeter:levelIndicator2 ];
    }
    
    cycle = ( cycle + 1 )%4 ;
    
    
}

-(void)convertToMono:(float**)buffers numberOfBuffers:(int)n samples:(int)samples outBuffer:(float*)output
{
    for(int s = 0;s<samples;s++)
    {
        for(int b = 0;b<n;b++)
        {
            output[s]+=buffers[b][s];
        }
        output[s]/=n;
    }
}


-(float)calculateRMS:(float*)buffer samples:(int)samples
{
    float sum;
    for (int i = 0; i < samples; i++ )
    {
        float square = buffer[i]*buffer[i];
        sum+=square;
    }
    float mean = sum/samples;
    //float rms = sqrtf(mean);
    float rms = mean;
    return rms;
}

@end
