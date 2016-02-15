//
//  DAAutomotivePolicyItemViewController.h
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/21/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAAutomotivePolicy.h"
#import "DAPolicyManager.h"

@class DAProgressHUD;
@protocol DAAutomotivePolicyItemViewControllerDelegate;

@interface DAAutomotivePolicyItemViewController : UITableViewController <DAPolicyManagerDelegate> {

	DAAutomotivePolicy	*automotivePolicy;
	DAProgressHUD		*savingHUD;
	
	id <DAAutomotivePolicyItemViewControllerDelegate> delegate;
}

@property (nonatomic, strong) DAAutomotivePolicy *automotivePolicy;
@property (nonatomic, strong) id <DAAutomotivePolicyItemViewControllerDelegate> delegate;

- (id)initWithAutomotivePolicy:(DAAutomotivePolicy *)policy;

@end

@protocol DAAutomotivePolicyItemViewControllerDelegate <NSObject>
@optional

- (void)didSaveAutomotivePolicy:(DAAutomotivePolicy *)policy;
@end