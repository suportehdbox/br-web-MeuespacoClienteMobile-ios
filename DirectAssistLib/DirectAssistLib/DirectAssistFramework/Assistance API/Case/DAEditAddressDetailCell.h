//
//  EditAddressDetailCell.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 04/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAEditAddressDetailCell : UITableViewCell {
	IBOutlet UITextView *txtAddressDetail;
}

@property (nonatomic, strong) UITextView *txtAddressDetail;

- (void) setAddressDetailText:(NSString *)text;

@end
