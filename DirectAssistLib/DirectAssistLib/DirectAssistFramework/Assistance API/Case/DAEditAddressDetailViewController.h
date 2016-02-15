//
//  EditAddressDetailViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 04/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DAEditAddressDetailCell;
@protocol EditAddressDetailViewControllerDelegate;

@interface DAEditAddressDetailViewController : UITableViewController <UITextViewDelegate> {
	IBOutlet DAEditAddressDetailCell *addressDetailCell;
	NSString *addressDetailText;
	
	id <EditAddressDetailViewControllerDelegate> delegate;
}

@property (nonatomic, strong) id <EditAddressDetailViewControllerDelegate> delegate;
@property (nonatomic, strong) NSString *addressDetailText;

- (IBAction)btnBack:(id)sender;
- (IBAction)btnSave:(id)sender;

@end

@protocol EditAddressDetailViewControllerDelegate <NSObject>
@optional

- (void)editAddressDetailViewController:(DAEditAddressDetailViewController *)editAddressDetailViewController 
				   didEditAddressDetail:(NSString *)addressDetail;

@end