//
//  PreviewView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/10/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "PreviewView.h"

@implementation PreviewView
@synthesize scrollView,imageView;


-(void) configureScrollView:(id<UIScrollViewDelegate>) delegate image:(UIImage*) image{
    self.scrollView.minimumZoomScale=1;
    self.scrollView.maximumZoomScale=3.0;
    self.scrollView.contentSize=CGSizeMake(self.frame.size.width, self.frame.size.height);
    self.scrollView.delegate=delegate;
    [self setBackgroundColor:[UIColor blackColor]];
    [scrollView setBackgroundColor:[UIColor blackColor]];
    [imageView setImage:image];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
