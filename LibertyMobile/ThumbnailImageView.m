//
//  ThumbnailImageView.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//


#import "ThumbnailImageView.h"

@interface ThumbnailImageView()
-(void)createHighlightImageViewIfNecessary;
@end

@implementation ThumbnailImageView

@synthesize delegate, sectionIndex, imageIndex;

- (void)dealloc {
    [highlightView release];
    
    [super dealloc];
}


#pragma mark -
#pragma mark Touch handling

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self createHighlightImageViewIfNecessary];
    [self addSubview:highlightView];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    [delegate thumbnailImageViewWasSelected:self];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event {
    [highlightView removeFromSuperview];
}

- (void)clearSelection {
    [highlightView removeFromSuperview];
}


#pragma mark -
#pragma mark Helper methods

- (void)createHighlightImageViewIfNecessary {
    if (!highlightView) {
        UIImage *thumbnailHighlight = [UIImage imageNamed:@"thumbnail_highlight.png"];
        highlightView = [[UIImageView alloc] initWithImage:thumbnailHighlight];
        [highlightView setAlpha: 0.5];
    }
}


@end
