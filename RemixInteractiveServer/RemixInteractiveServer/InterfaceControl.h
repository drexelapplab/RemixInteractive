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
#import "LightingCue.h"
#import <AudioLibrary/AFLibrary.h>
#import "SimpleFFT.h"

@interface InterfaceControl : NSObject <AFSoundcardDelegate>
{
    AppDelegate* delegate;
    
    //Lighting Cue Auto
    IBOutlet NSTextField* frameNumBox;
    IBOutlet NSTextField* frameTimeBox;
    IBOutlet NSTextField* elapsedTimeBox;
    IBOutlet NSTextField* jumpToBox;
    IBOutlet NSTextField* loadedFileBox;
    NSTimer *cueTimer;
    NSDate *cueTimerStart;
    int currentCue;
    float pausedTime;
    BOOL playingCues;
    BOOL fileLoaded;
    NSMutableArray* lightingCues;
    
    //Lighting Cue Design
    IBOutlet NSTextField* redBox;
    IBOutlet NSTextField* greenBox;
    IBOutlet NSTextField* blueBox;
    IBOutlet NSTextField* alphaBox;
    IBOutlet ColorGridView* colorsView;
    IBOutlet NSTextField* flashTimeField;
    IBOutlet NSTextField* editFrameTimeBox;
    IBOutlet NSTextField* editJumpToBox;
    
    
    
    //Audio Shit
    IBOutlet NSButton *audioInitButton;
    
	IBOutlet NSSlider *volumeSlider1;
	IBOutlet NSSlider *volumeSlider2;
	IBOutlet NSLevelIndicator *levelIndicator1;
	IBOutlet NSLevelIndicator *levelIndicator2;

    IBOutlet NSLevelIndicator *avgRMSIndicator;
    
    IBOutlet NSSlider *rmsScale;
	IBOutlet NSSlider *rmsPower;
    IBOutlet NSSlider *rmsTail;
    float prevDisplayRMS;
    bool prevJawnFlash;
    
    
    IBOutlet NSLevelIndicator *levelIndicatorFFT1;
	IBOutlet NSLevelIndicator *levelIndicatorFFT2;
    IBOutlet NSLevelIndicator *levelIndicatorFFT3;
	IBOutlet NSLevelIndicator *levelIndicatorFFT4;
    float movingMin;
    float movingMax;
    
    IBOutlet NSButton* checkBoxRMS;
    IBOutlet NSButton* checkBoxRMSFlash;
    IBOutlet NSButton* checkBoxFFT;
    
	AFManager *manager ;
	AFSoundcard *inputSoundcard, *outputSoundcard ;
	float level1, level2 ;
	int cycle ;
    
    
}
//Lighting Cue Auto
-(IBAction)loadCueFile:(id)sender;
-(IBAction)startCues:(id)sender;
-(IBAction)pauseCues:(id)sender;
-(IBAction)stopCues:(id)sender;
-(IBAction)jumpToPreviousCue:(id)sender;
-(IBAction)jumpToDefinedCue:(id)sender;
-(IBAction)jumpToNextCue:(id)sender;

//Lighting Cue Design
-(IBAction)sendColor:(id)sender;
-(IBAction)sendStatic:(id)sender;
-(IBAction)sendFlash:(id)sender;
-(IBAction)sendOff:(id)sender;
-(IBAction)initControl:(id)sender;
-(IBAction)selectAll:(id)sender;
-(IBAction)selectNone:(id)sender;
-(IBAction)editJumpToPreviousCue:(id)sender;
-(IBAction)editJumpToDefinedCue:(id)sender;
-(IBAction)editJumpToNextCue:(id)sender;
-(IBAction)editSaveCue:(id)sender;
-(IBAction)editSaveCurrentCueList:(id)sender;


//Audio Shit
-(IBAction)initAudio:(id)sender;


@end
