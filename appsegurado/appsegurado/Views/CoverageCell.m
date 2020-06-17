//
//  CoverageCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "CoverageCell.h"
#import "Tools.h"

@implementation CoverageCell
@synthesize lblTitle,lblValue,imgTitle,txtDetail;
@synthesize isTitle;
- (void)awakeFromNib {
    [super awakeFromNib];
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
    [imgTitle setContentMode:UIViewContentModeScaleAspectFit];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    BOOL selectedFinal = selected;
    if(selected && [self isSelected]){
        selectedFinal = false;
    }
    
    [super setSelected:selectedFinal animated:animated];
    if(!isTitle){
        return;
    }
    
    if (selectedFinal) {
        [_bgView setBackgroundColor:[Tools colorFromHexString:NSLocalizedString(@"CellBGSelected", @"")]];
        [lblTitle setTextColor:[UIColor whiteColor]];
        [lblValue setTextColor:[UIColor whiteColor]];
        [imgTitle setImage:[UIImage imageNamed:@"arrow_up"]];
    }else{
        [_bgView setBackgroundColor:[Tools colorFromHexString:NSLocalizedString(@"CellBG", @"")]];
        [lblTitle setTextColor:[UIColor darkGrayColor]];
        [lblValue setTextColor:[UIColor darkGrayColor]];
        
        [imgTitle setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    
    // Configure the view for the selected state
}

@end
