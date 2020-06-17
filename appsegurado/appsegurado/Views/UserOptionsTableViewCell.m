//
//  UserOptionsTableViewCell.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 07/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "UserOptionsTableViewCell.h"
#import "BaseView.h"

@implementation UserOptionsTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [self.lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [self.divisor setBackgroundColor:[BaseView getColor:@"CinzaClaro"]];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
