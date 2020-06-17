//
//  StatusViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "StatusViewCell.h"

@implementation StatusViewCell
@synthesize iconPolicy,iconStatus,lblPolicy,lblStatus,lblTitlePolicy, lblTitleDate,lblTitleClaim,lblDate,lblNumber, btOpenUpload, lblUpload;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
