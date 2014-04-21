//
//  ColorView.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface ColorView : NSView

-(void) setColor:(NSColor*)c;

@property (nonatomic, retain) NSColor* color;
@property (nonatomic) BOOL isSelected;
@end
