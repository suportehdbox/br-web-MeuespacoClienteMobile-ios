//
//  DAUserPhoneCell.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DAUserPhoneCell : UITableViewCell {
	IBOutlet UITextField *txtUserPhone;
}

@property (nonatomic, strong) UITextField *txtUserPhone;

@end
