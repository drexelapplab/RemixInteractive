//
//  ShittyColor.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/22/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "ShittyColor.h"

@implementation ShittyColor

-(id)initWithRed:(float)r green:(float)g blue:(float)b alpha:(float)a
{
    self = [super init];
    if (self)
    {
        _red = r;
        _green = g;
        _blue = b;
        _alpha = a;
    }
    return self;
}


@end
