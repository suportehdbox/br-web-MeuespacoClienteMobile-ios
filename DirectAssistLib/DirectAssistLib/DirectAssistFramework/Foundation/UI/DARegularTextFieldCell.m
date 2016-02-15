//
//  DARegularTextFieldCell.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/4/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DARegularTextFieldCell.h"


@implementation DARegularTextFieldCell

@synthesize textField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
		
		// Label
		//		self.textLabel.backgroundColor = [UIColor lightGrayColor];
		self.textLabel.textColor = [UIColor blueColor];
		self.textLabel.font = [UIFont boldSystemFontOfSize:13.0];
		self.textLabel.textAlignment = UITextAlignmentRight;
		
		// TextField
		textField = [[UITextField alloc] init];
		//		textField.backgroundColor = [UIColor lightGrayColor];
		textField.font = [UIFont boldSystemFontOfSize:14];
		textField.clearButtonMode = UITextFieldViewModeWhileEditing;
		textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
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
	frame= CGRectMake(boundsX + 10 , 5, 68, contentRect.size.height - 10);
	self.textLabel.frame = frame;
	
	frame= CGRectMake(boundsX + 84, 5, 200, contentRect.size.height - 10);
	textField.frame = frame;
}	

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	
    [super setSelected:selected animated:animated];
	
    // Configure the view for the selected state
}




@end
