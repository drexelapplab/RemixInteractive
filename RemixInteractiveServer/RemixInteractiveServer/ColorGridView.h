//
//  ColorGridView.h
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "ColorView.h"
@interface ColorGridView : NSView
@property (nonatomic, retain) NSMutableArray* viewList;
@property (nonatomic) int gridWidth;
@property (nonatomic) int gridHeight;

- (void)setupWithGridWidth:(int)w withGridHeight:(int)h;
- (void)sendRed;
- (void)sendGreen;
- (void)sendColorToComponent:(int)index withRed:(float)r withGreen:(float)g withBlue:(float)b withAlpha:(float)a;
- (id)initWithColorGridView:(ColorGridView*)gridView;
@end
