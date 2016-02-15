//
//  OficinasReferenciadasTableViewCell.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "OficinasReferenciadasTableViewCell.h"


@implementation OficinasReferenciadasTableViewCell

@synthesize lblEstabelecimento;
@synthesize lblEndereco;
@synthesize lblBairroCidadeUF;
@synthesize lblCEP;
@synthesize lblKm;

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

- (void)dealloc
{
    [super dealloc];
}

@end
