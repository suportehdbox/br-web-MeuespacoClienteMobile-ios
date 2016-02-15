//
//  AddressDetailCell.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 04/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAAddressDetailCell : UITableViewCell {
	IBOutlet UILabel *txtAddressDetail;
	IBOutlet UILabel *lblAddressDetail;
}

- (void) setCellDataWithText:(NSString *)text;
- (void) setFontColor:(UIColor *)fontColor;

@end
