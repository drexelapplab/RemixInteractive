//
//  LightingCue.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/22/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ShittyColor.h"
@interface LightingCue : NSObject
@property (nonatomic) int mins;
@property (nonatomic) int secs;
@property (nonatomic) int msecs;
@property (nonatomic,strong) NSString* cueTagString;
@property (nonatomic,strong) NSMutableArray* rgbValues;
-(id)initWithString:(NSString*)cueString;
@end
