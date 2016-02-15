//
//  ThumbnailImageView.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol ThumbnailImageViewSelectionDelegate;

@interface ThumbnailImageView : UIImageView {

	NSUInteger sectionIndex;
	NSUInteger imageIndex;
    UIImageView *highlightView;
    id <ThumbnailImageViewSelectionDelegate> delegate;
}

@property (nonatomic, assign) id<ThumbnailImageViewSelectionDelegate> delegate;
@property (nonatomic) NSUInteger sectionIndex;
@property (nonatomic) NSUInteger imageIndex;

- (void)clearSelection;

@end


@protocol ThumbnailImageViewSelectionDelegate <NSObject>
- (void)thumbnailImageViewWasSelected:(ThumbnailImageView *)thumbnailImageView;
@end
