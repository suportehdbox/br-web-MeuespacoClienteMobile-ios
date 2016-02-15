//
//  NotificacaoConsultaTableViewCell.m
//  LibertyMobile
//
//  Created by Evandro Oliveira on 20/01/2015.
//  Copyright 2015 Liberty Seguros S/A. All rights reserved.
//

#import "NotificacaoConsultaTableViewCell.h"

@implementation NotificacaoConsultaTableViewCell

@synthesize lblDate;
@synthesize txtAlert;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)dealloc
{
    [super dealloc];
}

@end
