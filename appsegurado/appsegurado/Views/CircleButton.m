//
//  CircleButton.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "CircleButton.h"

@implementation CircleButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) displayButtonWithTitle:(NSString*)title titleColor:(UIColor*) titleColor titleFont:(UIFont*)titleFont{
    
   
    NSMutableAttributedString *subTitleText = [[NSMutableAttributedString alloc] initWithString : title
                                                                                     attributes : @{
                                                                                                    NSFontAttributeName : titleFont,
                                                                                                    NSForegroundColorAttributeName : titleColor}];
    [self setAttributedTitle:subTitleText forState:UIControlStateNormal];
    
    [self.imageView setContentMode:UIViewContentModeCenter];
    
    [self.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [self.titleLabel setNumberOfLines:2];
    CGSize imageSize = self.imageView.frame.size;
    CGSize titleSize = self.titleLabel.frame.size;
    
    CGFloat totalHeight = (imageSize.height + titleSize.height);
    CGFloat marginButton = (CGRectGetWidth(self.frame) -  imageSize.width)/2;
    [self setImageEdgeInsets:UIEdgeInsetsMake(- (totalHeight - imageSize.height) - 15,
                                                 marginButton,
                                                 0.0f,
                                                 marginButton
                                                 )];
    
    [self setTitleEdgeInsets:UIEdgeInsetsMake((imageSize.height + titleSize.height)/2,
                                                 - imageSize.width,
                                                 - (totalHeight - imageSize.height),
                                                 0.0f)];
    

}
@end
