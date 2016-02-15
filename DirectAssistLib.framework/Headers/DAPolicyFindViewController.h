//
//  DAPolicyFindViewController.h
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DATextFieldCell.h"
#import "DAProgressHUD.h"
#import "DAPolicyFindBase.h"
#import "DAPolicyItemViewController.h"

@protocol DAPolicyFindDelegate;

@interface DAPolicyFindViewController : UITableViewController <UITextFieldDelegate, DAPolicyFindDelegate, DAPolicyItemViewControllerDelegate> {

	DAAssistanceType assistanceType;
	id <DAPolicyFindDelegate> delegate;
	
	NSString *policyKeyText;
	UIKeyboardType policyKeyKeyboardType;
	
	DATextFieldCell *policyKeyCell;
	DATextFieldCell *userDocumentCell;
	
	DAProgressHUD *loadingHUD;
}

@property (nonatomic, assign) DAAssistanceType assistanceType;
@property (nonatomic, strong) id <DAPolicyFindDelegate> delegate;
@property (nonatomic, copy) NSString *policyKeyText;
@property (nonatomic, assign) UIKeyboardType policyKeyKeyboardType;

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument;
- (void)didFindPolicy:(DAPolicyBase *)policyFound;
- (void)didFailWithErrorMessage:(NSString *)errorMessage;

- (IBAction)btnCancel:(id)sender;

@end
