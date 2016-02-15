//
//  TextFullFieldTableViewCell.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/27/12.
//
//

#import "TextFullFieldTableViewCell.h"

@implementation TextFullFieldTableViewCell

@synthesize txtField;

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
