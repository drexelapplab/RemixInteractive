//
//  ColorGridView.m
//  RemixInteractiveServer
//
//  Created by Matthew Prockup on 4/17/14.
//  Copyright (c) 2014 Matthew Prockup. All rights reserved.
//

#import "ColorGridView.h"

@implementation ColorGridView

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        
    }
    return self;
}

- (id)initWithColorGridView:(ColorGridView*)gridView{
    
    self = [super initWithFrame:gridView.frame];
    if (self)
    {
        _gridHeight = gridView.gridHeight;
        _gridWidth = gridView.gridWidth;
        _viewList = [[NSMutableArray alloc] init];
        int sectionWidth = gridView.frame.size.width/_gridHeight - 5;
        int sectionHeight = gridView.frame.size.height/_gridWidth - 5;
        for(int i = 0; i < _gridHeight; i++)
        {
            for(int j = 0; j<_gridWidth ; j++)
            {
                NSRect sectionGrid =  NSRectFromCGRect(CGRectMake(j*_gridWidth, i*_gridHeight, sectionWidth, sectionHeight));
                ColorView *sectionView = [[ColorView alloc] initWithFrame:sectionGrid];
                
                CGFloat comps[] = {0.5f, 0.5f, 0.5f, 1.0f};
                NSColor *aColor = [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace] components:comps count:4];
                [sectionView setColor:aColor];
                [_viewList addObject:sectionView];
                [self addSubview:sectionView];
                
                
                
            }
            
        }

    }
    return self;
    
}



- (id)initWithFrame:(NSRect)frame withGridWidth:(int)w withGridHeight:(int)h {
    self = [super initWithFrame:frame];
    if (self)
    {
        _gridHeight = h;
        _gridWidth = w;
        _viewList = [[NSMutableArray alloc] init];
        int sectionWidth = frame.size.width/w - 5;
        int sectionHeight = frame.size.height/h - 5;
        for(int i = 0; i < h; i++)
        {
            for(int j = 0; j<w ; j++)
            {
                NSRect sectionGrid =  NSRectFromCGRect(CGRectMake(j*w, i*h, sectionWidth, sectionHeight));
                ColorView *sectionView = [[ColorView alloc] initWithFrame:sectionGrid];
                [self addSubview:sectionView];
                
            }
            
        }
        
    }
    return self;
}

- (void)sendColorToComponent:(int)index withRed:(float)r withGreen:(float)g withBlue:(float)b withAlpha:(float)a
{
    CGFloat comps[] = {r, g, b, a};
    NSColor *aColor = [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace] components:comps count:4];
    [[_viewList objectAtIndex:index] setColor:aColor];
    [[_viewList objectAtIndex:index] setNeedsDisplay:YES];
    
}

- (void)sendRed
{
    for(int i = 0; i< [_viewList count]; i++)
    {
        CGFloat comps[] = {0.5f, 0.0f, 0.0f, 1.0f};
        NSColor *aColor = [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace] components:comps count:4];
        [[_viewList objectAtIndex:i] setColor:aColor];
        [[_viewList objectAtIndex:i] setNeedsDisplay:YES];
        
    }
}
-(void)sendGreen
{
    for(int i = 0; i< [_viewList count]; i++)
    {
        CGFloat comps[] = {0.0f, 0.5f, 0.0f, 1.0f};
        NSColor *aColor = [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace] components:comps count:4];
        [[_viewList objectAtIndex:i] setColor:aColor];
        [[_viewList objectAtIndex:i] setNeedsDisplay:YES];
        
    }
   
}

- (void)setupWithGridWidth:(int)w withGridHeight:(int)h {
    _viewList = [[NSMutableArray alloc] init];
    int sectionWidth = self.frame.size.width/w - 5;
    int sectionHeight = self.frame.size.height/h - 5;
    _gridHeight = h;
    _gridWidth = w;
    for(int i = 0; i < h; i++)
    {
        for(int j = 0; j< w ; j++)
        {
            NSRect sectionGrid =  NSRectFromCGRect(CGRectMake(j*(sectionWidth + 5), (h-i-1)*(sectionHeight+5), sectionWidth, sectionHeight));
            ColorView *sectionView = [[ColorView alloc] initWithFrame:sectionGrid];
            
            CGFloat comps[] = {0.5f, 0.5f, 0.5f, 1.0f};
            NSColor *aColor = [NSColor colorWithColorSpace:[NSColorSpace genericRGBColorSpace] components:comps count:4];
            [sectionView setColor:aColor];
            [_viewList addObject:sectionView];
            [self addSubview:sectionView];
        }
        
    }
    
}


- (void)drawRect:(NSRect)dirtyRect {
    // Fill in background Color
    
}


@end
