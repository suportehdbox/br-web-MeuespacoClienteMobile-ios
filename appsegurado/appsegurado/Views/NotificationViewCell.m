//
//  NotificationViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 14/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NotificationViewCell.h"

@implementation NotificationViewCell
@synthesize webview,bgView;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [webview.scrollView setScrollEnabled:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
