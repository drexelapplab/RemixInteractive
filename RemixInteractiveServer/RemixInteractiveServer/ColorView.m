//
//  ColorView.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "ColorView.h"

@implementation ColorView
- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
//        _color = NSColor *cColor = [aColor colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];

//        _color = [[NSColor blackColor] colorUsingColorSpace:[NSColorSpace genericRGBColorSpace]];
        _isSelected = NO;
    }
    return self;
}



-(void) setColor:(NSColor*)c{
    
    _color = c;
}

- (void)drawRect:(NSRect)dirtyRect {
    // Fill in background Color
    CGContextRef context = (CGContextRef) [[NSGraphicsContext currentContext] graphicsPort];
    CGContextSetRGBFillColor(context,
                             _color.redComponent,
                             _color.greenComponent,
                             _color.blueComponent,
                             _color.alphaComponent);
    
    
    
    CGContextFillRect(context, NSRectToCGRect(dirtyRect));
    
    
    if(_isSelected)
    {
        CGContextSetLineCap(context, kCGLineCapRound);
        CGContextSetLineWidth(context, 10.0);
        CGContextSetRGBStrokeColor(context, 0.5,0.0,0.0,1.0);
        CGContextBeginPath(context);
        CGContextMoveToPoint(context,    dirtyRect.origin.x, dirtyRect.origin.y);
        CGContextAddLineToPoint(context, dirtyRect.size.width, dirtyRect.origin.y);
        CGContextAddLineToPoint(context, dirtyRect.size.width, dirtyRect.size.height);
        CGContextAddLineToPoint(context, dirtyRect.origin.x, dirtyRect.size.height);
        CGContextAddLineToPoint(context, dirtyRect.origin.x, dirtyRect.origin.y);
        CGContextStrokePath(context);
    }
    
    
    
    
    NSLog(@"Drawing");
//    CGContextSetRGBFillColor(context, 0.0, 0.0, 0.0, 1.0);
    
    
    
    
    
    
}

- (void)mouseDown:(NSEvent *)theEvent{
    NSLog(@"Selected A Jawn");
    _isSelected = !_isSelected;
    [self setNeedsDisplay:YES];
}


@end
