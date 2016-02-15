//
//  DAPolicyListViewController.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/11/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPolicyListViewController.h"
#import "DAAutomotivePolicyManager.h"
#import "DAAutomakerPolicyManager.h"
#import "DAPropertyPolicyManager.h"
#import "DAPolicyBase.h"
#import "DAPropertyPolicy.h"
#import "DAAutomotivePolicy.h"
#import "DAAutomakerPolicy.h"

@implementation DAPolicyListViewController

@synthesize assistanceType, delegate, backButton, doneButton, editButton;

- (id) init {

    if (self = [super initWithNibName:@"DAPolicyListViewController" bundle:[NSBundle bundleForClass:[self class]]]) {

    	loadingHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Loading...", nil)];
		deletingHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Deleting...", nil)];
	}
    return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

    //self.navigationItem.rightBarButtonItem = self.editButtonItem;
	//self.navigationItem.rightBarButtonItem.enabled = NO;
	
	self.title = DALocalizedString(@"PolicyList", nil);

//    backButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnBack:) imageName:@"30_assistencia-nova-localmap-btn-nova.png"];
//    backButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnBack:) imageName:@"seta.png"];
    
    doneButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnDone:) imageName:@"btn-concluido.png"];
    editButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnEdit:) imageName:@"btn-editar.png"];
    
//    self.navigationItem.leftBarButtonItem = backButton;
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
    
    self.navigationItem.rightBarButtonItem = editButton;

	UIEdgeInsets edge;
	edge.bottom = 44;
	self.tableView.contentInset = edge;
	self.tableView.scrollIndicatorInsets = edge;	
	
	switch (assistanceType) {
		case kDAAssistanceTypeAutomotive:
			policyManager = [[DAAutomotivePolicyManager alloc] init];
			break;
		case kDAAssistanceTypeAutomaker:
			policyManager = [[DAAutomakerPolicyManager alloc] init];;
			break;
		case kDAAssistanceTypeProperty:
			policyManager = [[DAPropertyPolicyManager alloc] init];;
			break;
		default:
			break;
	}

	[policyManager setDelegate:self];
	
	if (nil == policyManager.policies) {
		
		[loadingHUD showWithNetworkActivityStatus];
		[policyManager listPolicies];
	}
	else {
		self.navigationItem.rightBarButtonItem.enabled = [policyManager.policies count] > 0;
	}
}


- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	
	[loadingHUD dismiss];
	[deletingHUD dismiss];
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

-(IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)btnEdit:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.doneButton;
    [self.tableView setEditing:YES];
}

-(IBAction)btnDone:(id)sender
{
    self.navigationItem.rightBarButtonItem = self.editButton;
    [self.tableView setEditing:NO];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return ([policyManager.policies count] > 0 ? 2 : 1);
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 && [policyManager.policies count] > 0) ? [policyManager.policies count] : 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return (indexPath.section == 0 && [policyManager.policies count] > 0) ? 60 : 44;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
 	if (indexPath.section == 0 && [policyManager.policies count] > 0) {
		
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
		}
		
		// Set up the cell...
		DAPolicyBase *policy = [policyManager.policies objectAtIndex:indexPath.row];
		cell.detailTextLabel.text = [policy.customerName wordCapitalizedString];

		switch (assistanceType) {
			case kDAAssistanceTypeAutomotive:				
				cell.textLabel.text = [(DAAutomotivePolicy *)policy vehiclePlate];
				break;
			case kDAAssistanceTypeAutomaker:				
				cell.textLabel.text = [(DAAutomakerPolicy *)policy vehicleModel];
				break;
			case kDAAssistanceTypeProperty:				
				cell.textLabel.text = [(DAPropertyPolicy *)policy policyID];
				break;
			default:
				break;
		}
		
		return cell;
	}
	else {
		
		static NSString *CellIdentifier = @"AddPolicyCell";
		
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
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 0 && [policyManager.policies count] > 0) {
		
		DAPolicyBase *policy = [policyManager.policies objectAtIndex:indexPath.row];
		
		NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
		[userDefaults setInteger:policy.groupID forKey:FOOTER_GROUP_ID_KEY];
		[[NSNotificationCenter defaultCenter] postNotificationName:FOOTER_GROUP_ID_CHANGE_NOTIFICATION object:self];	

		if ([delegate respondsToSelector:@selector(policyListViewControllerDelegate:didSelectPolicy:)])
			[delegate policyListViewControllerDelegate:self didSelectPolicy:policy];

	}
	else {
		
		
		UIViewController *finderVC;
		
		switch (assistanceType) {
			case kDAAssistanceTypeAutomotive: {
				finderVC = [[DAAutomotivePolicyFindViewController alloc] init];
				[(DAAutomotivePolicyFindViewController *)finderVC setDelegate:self];
				break;
			}
			case kDAAssistanceTypeAutomaker: {
				finderVC = [[DAAutomakerPolicyFindViewController alloc] init];
				[(DAAutomakerPolicyFindViewController *)finderVC setDelegate:self];
				break;
			}
			case kDAAssistanceTypeProperty: {
				finderVC = [[DAPropertyPolicyFindViewController alloc] init];
				[(DAPropertyPolicyFindViewController *)finderVC setDelegate:self];
				break;
			}
			default:
				break;
		}
		
		[self.navigationController pushViewController:finderVC animated:YES];
	}
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return ([policyManager.policies count] > 0 && indexPath.section == 0);
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
		
		[deletingHUD showWithNetworkActivityStatus];
		
        // Delete the row from the data source
		DAPolicyBase *policy = [policyManager.policies objectAtIndex:indexPath.row];
		
		[policyManager deletePolicy:policy];
		
		[policyManager.policies removeObjectAtIndex:indexPath.row];
		
		if ([policyManager.policies count] == 0) {
		
			[self.tableView setEditing:NO];
			
			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
			[userDefaults setInteger:0 forKey:FOOTER_GROUP_ID_KEY];
			[[NSNotificationCenter defaultCenter] postNotificationName:FOOTER_GROUP_ID_CHANGE_NOTIFICATION object:self];	
		}
	}   
}

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark DAPolicyManagerDelegate methods 

- (void)policyManager:(DAPolicyManager *)policyManagerObj didListPolicies:(NSArray *)policiesFound {

	[loadingHUD dismiss];
	
	policyManager.policies = [NSMutableArray arrayWithArray:policiesFound];
	self.navigationItem.rightBarButtonItem.enabled = [policyManager.policies count] > 0;

	[self.tableView reloadData];
}

- (void)policyManager:(DAPolicyManager *)policyManagerObj listPoliciesDidFailWithErrorMessage:(NSString *)errorMessage {

	[loadingHUD dismiss];

	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"CantListPolicies", nil) 
													message:errorMessage 
												   delegate:nil 
										  cancelButtonTitle:nil 
										  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[alert show];
}

- (void)policyManager:(DAPolicyManager *)policyManager didDeletePolicy:(DAPolicyBase *)deletedPolicy {

	[deletingHUD dismiss];
	[self.tableView reloadData];	
}

- (void)policyManager:(DAPolicyManager *)policyManager deletePolicyDidFailWithErrorMessage:(NSString *)errorMessage {

	[deletingHUD dismiss];
	[self.tableView reloadData];
}		

#pragma mark DAPolicyListDelegate methods

- (void)findPolicyWS:(id)findPolicyWS didFindPolicy:(DAPolicyBase *)policyFound {
	
	[policyManager.policies addObject:policyFound];
	
	if ([delegate respondsToSelector:@selector(policyListViewControllerDelegate:didSelectPolicy:)])
		[delegate policyListViewControllerDelegate:self didSelectPolicy:policyFound];
}



@end

