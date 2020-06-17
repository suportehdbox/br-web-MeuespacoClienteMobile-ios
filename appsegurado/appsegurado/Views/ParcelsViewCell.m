//
//  ParcelsViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ParcelsViewCell.h"
#import "BaseView.h"

@implementation ParcelsViewCell
@synthesize bgView,lblDate,lblValue,lblStatus,lblNumParcel;
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [lblDate setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblValue setFont:[BaseView getDefatulFont:Small bold:YES]];
    [lblStatus setFont:[BaseView getDefatulFont:Small bold:NO]];
    [lblNumParcel setFont:[BaseView getDefatulFont:Small bold:NO]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
