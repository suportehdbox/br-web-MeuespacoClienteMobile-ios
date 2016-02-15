//
//  DAContactListViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@class DAContact;
@protocol DAContactListViewControllerDelegate;

@interface DAContactListViewController : UITableViewController {
	NSArray *contactsList;
	id <DAContactListViewControllerDelegate> __unsafe_unretained delegate;
	CLLocationCoordinate2D searchReferenceCoordinate;
}

@property (nonatomic, unsafe_unretained) id <DAContactListViewControllerDelegate> delegate;
@property (nonatomic, assign) CLLocationCoordinate2D searchReferenceCoordinate;

- (void)showContacts:(NSArray *)contacts;

@end

@protocol DAContactListViewControllerDelegate <NSObject>
@optional

- (void)contactListViewController:(DAContactListViewController *)contactMapViewController 
				didSelectContact:(DAContact *)contact;
@end