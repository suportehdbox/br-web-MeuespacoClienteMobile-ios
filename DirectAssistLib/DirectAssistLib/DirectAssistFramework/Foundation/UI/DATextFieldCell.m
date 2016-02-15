//
//  DATextFieldCell.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/20/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DATextFieldCell.h"

@implementation DATextFieldCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		
		// Label
//		self.textLabel.backgroundColor = [UIColor lightGrayColor];
		self.textLabel.textColor = [UIColor blueColor];
		self.textLabel.font = [UIFont boldSystemFontOfSize:14.0];
		self.textLabel.textAlignment = UITextAlignmentRight;
	
		// TextField
		textField = [[UITextField alloc] init];
//		textField.backgroundColor = [UIColor lightGrayColor];
		textField.font = [UIFont systemFontOfSize:24];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;		
		[self.contentView addSubview:textField];	
		
		self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews {
	
	[super layoutSubviews];
	
	CGRect contentRect = self.contentView.bounds;
	CGFloat boundsX = contentRect.origin.x;
	CGRect frame;
	frame= CGRectMake(boundsX + 10 , 8, 75, contentRect.size.height - 10);
	self.textLabel.frame = frame;
	
	frame= CGRectMake(boundsX + 95, 8, 195, contentRect.size.height - 4);
	textField.frame = frame;
}	

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {

    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}




@end
