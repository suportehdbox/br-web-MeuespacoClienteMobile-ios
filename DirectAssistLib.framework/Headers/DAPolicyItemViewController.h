//
//  DAPolicyItemViewController.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressHUD.h"
#import "DAPolicyManager.h"

@class DAPolicyBase, DALocationCell;
@protocol DAPolicyItemViewControllerDelegate;

@interface DAPolicyItemViewController : UITableViewController <DAPolicyManagerDelegate> {

	DAPolicyBase		*policy;
	DAAssistanceType	assistanceType;
	
	DAProgressHUD	*savingHUD;
	IBOutlet DALocationCell	*locationCell;
	
	id <DAPolicyItemViewControllerDelegate> delegate;
    
    BOOL isHeliar;
}

@property (nonatomic, strong) DAPolicyBase	*policy;
@property (nonatomic, assign) DAAssistanceType assistanceType;
@property (nonatomic, strong) id <DAPolicyItemViewControllerDelegate> delegate;

- (id)initWithPolicy:(DAPolicyBase *)policyItem;
- (IBAction)btnCancel:(id)sender;

@end

@protocol DAPolicyItemViewControllerDelegate <NSObject>
@optional

- (void)policyItemViewController:(DAPolicyItemViewController *)policyItemViewController
							didSavePolicy:(DAPolicyBase *)savedPolicy;
@end