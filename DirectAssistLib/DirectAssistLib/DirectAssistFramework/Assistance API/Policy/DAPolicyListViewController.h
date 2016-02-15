//
//  DAPolicyListViewController.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressHUD.h"
#import "DAPolicyManager.h"
#import "DAAutomotivePolicyFindViewController.h"
#import "DAPropertyPolicyFindViewController.h"
#import "DAAutomakerPolicyFindViewController.h"
#import "DAPolicyFindBase.h"

@protocol DAPolicyListViewControllerDelegate;

@interface DAPolicyListViewController : UITableViewController <DAPolicyManagerDelegate, DAPolicyFindDelegate> {

	DAAssistanceType assistanceType;
	DAPolicyManager *policyManager;
	
	DAProgressHUD *loadingHUD;
	DAProgressHUD *deletingHUD;
    
    IBOutlet UIBarButtonItem *backButton;
    IBOutlet UIBarButtonItem *doneButton;
    IBOutlet UIBarButtonItem *editButton;

	id <DAPolicyListViewControllerDelegate> delegate;
}

@property (nonatomic, strong) IBOutlet UIBarButtonItem *backButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *doneButton;
@property (nonatomic, strong) IBOutlet UIBarButtonItem *editButton;

@property (nonatomic, assign) DAAssistanceType assistanceType;
@property (nonatomic, strong) id <DAPolicyListViewControllerDelegate> delegate;

-(IBAction)btnBack:(id)sender;
-(IBAction)btnDone:(id)sender;
-(IBAction)btnEdit:(id)sender;

@end

@protocol DAPolicyListViewControllerDelegate <NSObject>
@optional

- (void)policyListViewControllerDelegate:(DAPolicyListViewController *)policyListViewControllerDelegate
						  didSelectPolicy:(DAPolicyBase *)selectedPolicy;
@end
