//
//  CheckBoxTableViewCell.m
//  LibertyMobile
//
//  Created by Evandro Oliveira on 9/6/15.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "CheckBoxTableViewCell.h"


@implementation CheckBoxTableViewCell

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

/*
-(IBAction)btnCheckBox:(id)sender
{
    if([_BtnCheckBox isSelected]){
        self.selecionado = NO;
    }else{
        self.selecionado = YES;
    }
    _BtnCheckBox.selected = !_BtnCheckBox.selected;
}*/

@end
