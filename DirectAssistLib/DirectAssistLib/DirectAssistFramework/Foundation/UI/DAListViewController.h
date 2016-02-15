//
//  DAListViewController.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol DAListViewControllerDelegate;

@interface DAListViewController : UITableViewController {

	id <DAListViewControllerDelegate> delegate;
	
	NSArray *listItems;
	NSInteger tag;
	NSString *headerText;
	BOOL showCallToAssistanceOption;
	
	DAKeyValue *preselectedItem;
	DAAssistanceType assistanceType;
}

@property (nonatomic, strong) id <DAListViewControllerDelegate> delegate;
@property (nonatomic, strong) NSArray *listItems;
@property (assign) NSInteger tag;
@property (nonatomic, copy) NSString *headerText;
@property (nonatomic, assign) BOOL showCallToAssistanceOption;
@property (nonatomic, strong) DAKeyValue *preselectedItem;
@property (nonatomic, assign) DAAssistanceType assistanceType;

- (id)initWithListItems:(NSArray *)items title:(NSString *)viewTitle tag:(NSInteger)viewTag;
- (IBAction)btnBack:(id)sender;

@end

@protocol DAListViewControllerDelegate <NSObject>
@optional

- (void)listViewController:(DAListViewController *)listViewController didSelectItem:(DAKeyValue *)item;

@end