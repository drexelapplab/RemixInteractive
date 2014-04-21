//
//  LocateMeView.m
//  Heartbeat
//
//  Created by Jordan Zagerman on 4/11/14.
//  Copyright (c) 2014 Jordan Zagerman. All rights reserved.
//

#import "LocateMeView.h"

@implementation LocateMeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
-(void) touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UITouch *touch = [touches anyObject];
    
    CGPoint point = [touch locationInView:self];
    
    CGFloat x = point.x;
    
    CGFloat y = point.y;
    
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    
    CGFloat xPercent = x / width;
    
    CGFloat yPercent = y / height;
    
    int xCoordinate;
    int yCoordinate;
    
    
    if (xPercent < 0.25)
        xCoordinate = 0;
    else if (xPercent < 0.5)
        xCoordinate = 1;
    else if (xPercent < 0.75)
        xCoordinate = 2;
    else
        xCoordinate = 3;
    
    if (yPercent < 0.25)
        yCoordinate = 0;
    else if (yPercent < 0.5)
        yCoordinate = 1;
    else if (yPercent < 0.75)
        yCoordinate = 2;
    else
        yCoordinate = 3;
    
    
    int index = yCoordinate*(4) + xCoordinate;
    self.currentPositionIndex = index;
    
    NSLog(@"SELECTED INDEX: %d",index);
    self.hidden = YES;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

@end
