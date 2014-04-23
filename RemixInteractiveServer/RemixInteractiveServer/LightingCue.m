//
//  LightingCue.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/22/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "LightingCue.h"

@implementation LightingCue
-(id)initWithString:(NSString*)cueString
{
    self = [super init];
    if (self)
    {
        NSArray* packetPieces = [cueString componentsSeparatedByString:@"|"];
        if([packetPieces count]>2){
            
            _cueTagString = [packetPieces objectAtIndex:0];
            
            NSArray* timePieces = [[packetPieces objectAtIndex:1] componentsSeparatedByString:@":"];
            _mins = [[timePieces objectAtIndex:0] intValue];
            if(_mins==12)
            {
                _mins=0;
            }
            _secs = [[timePieces objectAtIndex:1] intValue];
            _msecs = [[timePieces objectAtIndex:2] intValue];
            
            NSString* colorsString = [packetPieces objectAtIndex:2];
            NSMutableArray* colorStrings = (NSMutableArray*)[colorsString componentsSeparatedByString:@"}{"];
            [colorStrings replaceObjectAtIndex:0 withObject:[[colorStrings objectAtIndex:0] substringFromIndex:1]];
            [colorStrings replaceObjectAtIndex:([colorStrings count]-1) withObject:[[colorStrings objectAtIndex:([colorStrings count]-1)] substringToIndex:( [[colorStrings objectAtIndex:([colorStrings count]-1)] length]-1 )]];
            
            
            _rgbValues = [[NSMutableArray alloc] init];
            
            for(int i=0;i<[colorStrings count];i++)
            {
                NSString* singleRGB = [colorStrings objectAtIndex:i];
                NSArray* colorVals = [singleRGB componentsSeparatedByString:@","];
                float r = [[colorVals objectAtIndex:0] floatValue];
                float g = [[colorVals objectAtIndex:1] floatValue];
                float b = [[colorVals objectAtIndex:2] floatValue];
                float a = [[colorVals objectAtIndex:3] floatValue];
                ShittyColor* colorTemp = [[ShittyColor alloc] initWithRed:r green:g blue:b alpha:a];
                [_rgbValues addObject:colorTemp];
            }
            
        }
    }
    return self;
}
@end
