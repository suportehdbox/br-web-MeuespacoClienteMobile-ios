//
//  MinhasApolicesDetalheTableViewCell.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MinhasApolicesDetalhe2TableViewCell.h"

@implementation MinhasApolicesDetalhe2TableViewCell

@synthesize lblStatusPagamento;
@synthesize lblStatusParcelas;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
