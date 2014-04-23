//
//  ShittyColor.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/22/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShittyColor : NSObject

@property (nonatomic) float red;
@property (nonatomic) float green;
@property (nonatomic) float blue;
@property (nonatomic) float alpha;

-(id)initWithRed:(float)r green:(float)g blue:(float)b alpha:(float)a;
@end
