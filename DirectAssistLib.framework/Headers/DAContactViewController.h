//
//  DAContactViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/15/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAContactMapViewController.h"
#import "DAContactListViewController.h"
#import "DAAddressFinderViewController.h"
//#import "TTARViewController.h"

@class DAContactListViewController, DAContactMapViewController, DAContact;

@interface DAContactViewController : UIViewController <DAContactMapViewControllerDelegate, DAContactListViewControllerDelegate, DAAddressFinderViewControllerDelegate> {
	
	IBOutlet UIToolbar *toolbar;
	IBOutlet UIView *contentView;
	IBOutlet UISegmentedControl *viewType;
	IBOutlet UIBarButtonItem *searchButton;
	
	DAContactListViewController *listVC;
	DAContactMapViewController *mapVC;
//	TTARViewController *arVC;
	
	NSString *contactViewTitle;
	CLLocationCoordinate2D searchReferenceCoordinate;
}

@property (nonatomic, copy) NSString *contactViewTitle;
@property (nonatomic, readonly) CLLocationCoordinate2D searchReferenceCoordinate;

- (IBAction)viewTypeChanged:(id)sender;
- (IBAction)searchButtonTapped:(id)sender;
- (void)changeView:(int)index;

- (void)loadContacts;
- (void)showContacts:(NSArray *)contacts;
- (void)pushContactView:(DAContact *)contact;
@end
