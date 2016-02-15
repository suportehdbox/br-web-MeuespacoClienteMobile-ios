//
//  SinistroConsultaTableViewCell.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SinistroConsultaTableViewCell.h"


@implementation SinistroConsultaTableViewCell

@synthesize lblEnviado;
@synthesize lblTipo;
@synthesize lblData;
@synthesize lblLocal;

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
    
    /*
    if (self.editing) {
        
        [lblTipo setFrame:CGRectMake(lblTipo.frame.origin.x, lblTipo.frame.origin.y, 175, lblTipo.frame.size.height)];
		[lblData setFrame:CGRectMake(lblData.frame.origin.x, lblData.frame.origin.y, 120, lblData.frame.size.height)];
		[lblLocal setFrame:CGRectMake(lblLocal.frame.origin.x, lblLocal.frame.origin.y, 120, lblLocal.frame.size.height)];
    }
    else {
		[lblTipo setFrame:CGRectMake(lblTipo.frame.origin.x, lblTipo.frame.origin.y, 230, lblTipo.frame.size.height)];
		[lblData setFrame:CGRectMake(lblData.frame.origin.x, lblData.frame.origin.y, 160, lblData.frame.size.height)];
		[lblLocal setFrame:CGRectMake(lblLocal.frame.origin.x, lblLocal.frame.origin.y, 160, lblLocal.frame.size.height)];
    }
     */
    [super layoutSubviews];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc
{
    [super dealloc];
}

@end
