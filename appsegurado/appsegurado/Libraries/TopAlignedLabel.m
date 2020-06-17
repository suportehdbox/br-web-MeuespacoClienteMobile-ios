//
//  TopAlignedLabel.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/12/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "TopAlignedLabel.h"

@implementation TopAlignedLabel

- (void)drawTextInRect:(CGRect)rect {
    if ([ [ UIScreen mainScreen ] bounds ].size.height <= 568){
            [super drawTextInRect:rect];
    }else{
        if (self.text) {
            CGSize labelStringSize = [self.text boundingRectWithSize:CGSizeMake(CGRectGetWidth(self.frame), CGFLOAT_MAX)
                                                             options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                                          attributes:@{NSFontAttributeName:self.font}
                                                             context:nil].size;
            [super drawTextInRect:CGRectMake(0, 0, ceilf(CGRectGetWidth(self.frame)),ceilf(labelStringSize.height))];
        } else {
            [super drawTextInRect:rect];
        }
    }
}

- (void)prepareForInterfaceBuilder {
    [super prepareForInterfaceBuilder];
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor blackColor].CGColor;
}
@end
