//
//  CorretorSinistrosFiltroTableViewCell.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/26/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TituloTableViewCell.h"

@implementation TituloTableViewCell

@synthesize lblTitulo;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

@end
