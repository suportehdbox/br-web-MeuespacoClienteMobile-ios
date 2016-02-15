//
//  DAAutomakerPolicyItemViewController.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAutomakerPolicy.h"
#import "DAPolicyManager.h"
#import "DAProgressHUD.h"

@protocol DAAutomakerPolicyItemViewControllerDelegate;

@interface DAAutomakerPolicyItemViewController : UITableViewController <DAPolicyManagerDelegate> {
	
	DAAutomakerPolicy	*automakerPolicy;
	DAProgressHUD		*savingHUD;
	
	id <DAAutomakerPolicyItemViewControllerDelegate> delegate;
}

@property (nonatomic, strong) DAAutomakerPolicy *automakerPolicy;
@property (nonatomic, strong) id <DAAutomakerPolicyItemViewControllerDelegate> delegate;

- (id)initWithPolicy:(DAAutomakerPolicy *)policy;

@end

@protocol DAAutomakerPolicyItemViewControllerDelegate <NSObject>
@optional

- (void)automakerPolicyItemViewController:(DAAutomakerPolicyItemViewController *)automakerPolicyItemViewController
				  didSavePolicy:(DAAutomakerPolicy *)policy;
@end