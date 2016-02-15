//
//  DAUserPhoneViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 05/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAUserPhoneCell;

@interface DAUserPhoneViewController : UITableViewController <UITextFieldDelegate> {

	IBOutlet DAUserPhoneCell *phoneCell;
	BOOL updatePhone;
	NSString *basePhone;
	NSString *formattedPhone;
    NSString *ddd11;
}

@property (nonatomic, strong) NSString *basePhone;
@property (nonatomic, strong) NSString *ddd11;

- (NSString *) formatPhoneNumber:(NSString *)phoneNumber;

@end