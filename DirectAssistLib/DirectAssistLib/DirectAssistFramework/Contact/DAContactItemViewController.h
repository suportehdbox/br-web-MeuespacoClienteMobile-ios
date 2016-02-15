//
//  DAContactViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/10/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBookUI/AddressBookUI.h>

@class DAContact;

@interface DAContactItemViewController : UITableViewController <ABNewPersonViewControllerDelegate> {
	DAContact *contact;
	UINavigationController *newPersonNavController;
	ABNewPersonViewController *newPersonVC;
}

@property (nonatomic, strong) DAContact *contact;

- (id)initWithContact:(DAContact *)viewContact;
- (id)initWithContact:(DAContact *)viewContact viewTitle:(NSString *)viewTitle;

- (UIView *) getHeader:(NSString *)label withButtonText:(NSString *)buttonText;

@end
