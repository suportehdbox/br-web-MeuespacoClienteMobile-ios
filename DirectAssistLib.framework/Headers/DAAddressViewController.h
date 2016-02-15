//
//  DAAddressViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/8/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAddress.h"
#import "DARegularTextFieldCell.h"

@protocol DAAddressViewControllerDelegate;

@interface DAAddressViewController : UITableViewController {
	
	DAAddress *address;
	id <DAAddressViewControllerDelegate> delegate;
	
	DARegularTextFieldCell *houseNumberCell;
}

@property (nonatomic, strong) DAAddress *address;
@property (nonatomic, strong) id <DAAddressViewControllerDelegate> delegate;

@end

@protocol DAAddressViewControllerDelegate <NSObject>
@optional

- (void)addressViewController:(DAAddressViewController *)addressViewController didSaveAddress:(DAAddress *)savedAddress;

@end