//
//  DAPolicyFindViewController.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPolicyFindViewController.h"
#import "DAWebServiceActionResult.h"
#import "DAAccessLog.h"
#import "DAPolicyBase.h"

@implementation DAPolicyFindViewController

enum kDASearchingModeRows {
	kDASearchingModePolicyKeyRow = 0,
	kDASearchingModeUserDocRow,
	kDASearchingModeTotalRows
};

@synthesize assistanceType, policyKeyText, policyKeyKeyboardType, delegate;

- (id)init {
    self = [super initWithNibName:@"DAPolicyFindViewController" bundle:[NSBundle bundleForClass:[self class]]];
    if (self) {

		loadingHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Loading...", nil)];				  
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnCancel:)];
}
							
- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	BOOL dismissUserDocument = [DAConfiguration settings].applicationClient.findPolicyDismissUserDocument;
	return (section == 0 ? kDASearchingModeTotalRows - (dismissUserDocument ? 1 : 0) : 1);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) { 
		switch (indexPath.row) {
			case kDASearchingModePolicyKeyRow: {
				static NSString *CellIdentifier = @"policyKeyCell";
				
				policyKeyCell = (DATextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (policyKeyCell == nil) {
					policyKeyCell = [[DATextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				}
				
				policyKeyCell.textLabel.text = [policyKeyText lowercaseString];
				policyKeyCell.textLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
				policyKeyCell.textField.adjustsFontSizeToFitWidth = YES;
				
				policyKeyCell.textField.delegate = self;
				policyKeyCell.textField.keyboardType = policyKeyKeyboardType;
				policyKeyCell.textField.autocapitalizationType = UITextAutocapitalizationTypeAllCharacters;
				policyKeyCell.textField.returnKeyType = UIReturnKeyNext;
				[policyKeyCell.textField becomeFirstResponder];
				
				return policyKeyCell;
				break;
			}
			case 1: {
				static NSString *CellIdentifier = @"userDocumentCell";
				
				userDocumentCell = (DATextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
				if (userDocumentCell == nil) {
					userDocumentCell = [[DATextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
				}	
				userDocumentCell.textLabel.text = [DALocalizedString(@"UserDocument", nil) lowercaseString];
				userDocumentCell.textLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
				userDocumentCell.textField.delegate = self;
				userDocumentCell.textField.keyboardType = UIKeyboardTypeNumberPad;
				return userDocumentCell;
				break;
			}
		}
	} else {
		static NSString *CellIdentifier = @"searchCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"26_assistencia-novaescolheradd-btn-add.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell setBackgroundColor:[UIColor clearColor]];
		[cell setBackgroundView:backgroundImageView];

		return cell;
	}
	
	return nil;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 1) {

		if (![Utility hasInternet]) {			
			[Utility showNoInternetWarning];
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
			return;
		}
		
		[loadingHUD showWithNetworkActivityStatus];
		[self findPolicyWithPolicyKey:policyKeyCell.textField.text 
						 userDocument:userDocumentCell.textField.text];
	}
}

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark UITextFieldDelegate methods

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	if (textField == policyKeyCell.textField) {
		
		[userDocumentCell.textField becomeFirstResponder];
	}
	
	return YES;
}

#pragma mark DAPolicyFindViewController methods

- (void)findPolicyWithPolicyKey:(NSString *)policyKey userDocument:(NSString *)userDocument {
}

- (void)didFindPolicy:(DAPolicyBase *)policyFound {
	
	[loadingHUD dismiss];
	
	DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] init];
	actionResult.actionType = kDAActionFindPolicy;	
	actionResult.actionParameters = [NSString stringWithFormat:@"%@|%@", policyKeyCell.textField.text,
									 userDocumentCell.textField.text];
    
    [userDocumentCell.textField becomeFirstResponder];
    [userDocumentCell.textField resignFirstResponder];
    
	if (nil == policyFound || nil == policyFound.policyID || policyFound.policyID.length == 0 ) {
	
		[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];

		actionResult.resultType = kDAResultNotFound;
        NSString *message;
        if (self.assistanceType == kDAAssistanceTypeProperty) {
            message = DALocalizedString(@"PolicyNotFound", nil);
        } else {
            message = DALocalizedString(@"PolicyNotFoundAutomotive", nil);
        }
		UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:nil 
															 message:message
															delegate:nil 
												   cancelButtonTitle:nil 
												   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
		[errorAlert show];
		return;
	}
	else 
		actionResult.resultType = kDAResultSuccess;
	
	[DAAccessLog saveAccessLog:actionResult];
	
	DAPolicyItemViewController *policyVC = [[DAPolicyItemViewController alloc] initWithPolicy:policyFound];
	[policyVC setAssistanceType:assistanceType];
	[policyVC setDelegate:self];
	[self.navigationController pushViewController:policyVC animated:YES];	
}

- (void)didFailWithErrorMessage:(NSString *)errorMessage {
	
	[self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:NO];

	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"CantFindPolicy", nil)  
														 message:errorMessage
														delegate:nil 
											   cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
	
}

#pragma mark DAPolicyItemViewControllerDelegate methods 

- (void)policyItemViewController:(DAPolicyItemViewController *)policyItemViewController didSavePolicy:(DAPolicyBase *)savedPolicy {

	if ([delegate respondsToSelector:@selector(findPolicyWS:didFindPolicy:)])
		[delegate findPolicyWS:self didFindPolicy:savedPolicy];
	
}



@end

