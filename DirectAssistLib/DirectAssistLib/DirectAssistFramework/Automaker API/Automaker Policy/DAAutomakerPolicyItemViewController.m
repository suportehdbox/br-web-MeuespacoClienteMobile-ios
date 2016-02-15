//
//  DAAutomakerPolicyItemViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAutomakerPolicyItemViewController.h"
#import "DAWebServiceActionResult.h"
#import "DAAccessLog.h"

enum kDAViewModeRows {
	kDAViewModePolicyIDRow = 0,
	kDAViewModeUserNameRow,
	kDAViewModeVehicleChassisRow,
	kDAViewModeVehicleModelRow,
	kDAViewModeTotalRows
};


@implementation DAAutomakerPolicyItemViewController

@synthesize automakerPolicy, delegate;

- (id)initWithPolicy:(DAAutomakerPolicy *)policy {
	
	if (self = [self init]) {
		[self setAutomakerPolicy:policy];
	}
	return self;
}

- (id)init {
	
	if (self = [super initWithNibName:@"DAAutomakerPolicyItemViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"Vehicle", nil);
	savingHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Saving...", nil)];
}

/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/
/*
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}
*/

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[savingHUD dismiss];
}

/*
- (void)viewDidDisappear:(BOOL)animated {
	[super viewDidDisappear:animated];
}
*/

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

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
	return (section == 0 ? kDAViewModeTotalRows : 1);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == 0) {
		
		static NSString *CellIdentifier = @"viewCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
		}	
		
		switch (indexPath.row) {
			case kDAViewModePolicyIDRow:
				cell.textLabel.text = [DALocalizedString(@"Policy", nil) lowercaseString];
				cell.detailTextLabel.text = self.automakerPolicy.policyID;
				break;
			case kDAViewModeUserNameRow:
				cell.textLabel.text = [DALocalizedString(@"Name", nil) lowercaseString];
				cell.detailTextLabel.text = [self.automakerPolicy.customerName wordCapitalizedString];
				break;
			case kDAViewModeVehicleModelRow:
				cell.textLabel.text = [DALocalizedString(@"VehicleModel", nil) lowercaseString];
				cell.detailTextLabel.text = self.automakerPolicy.vehicleModel;
				break;
			case kDAViewModeVehicleChassisRow:
				cell.textLabel.text = [DALocalizedString(@"VehicleChassis", nil) lowercaseString];
				cell.detailTextLabel.text = self.automakerPolicy.vehiclePlate;
				break;
			default:
				break;
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	else {
		static NSString *CellIdentifier = @"saveCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}	
		
		cell.textLabel.text = DALocalizedString(@"SaveVehicle", nil);
		cell.textLabel.textAlignment = UITextAlignmentCenter;
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		return cell;
	}
	return nil;	
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 1) {
		[savingHUD showWithNetworkActivityStatus];
		
		DAPolicyManager *policyManager = [[DAPolicyManager alloc] init];
		[policyManager setDelegate:self];
		[policyManager savePolicy:self.automakerPolicy];
	}
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/


/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:YES];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/


/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/


/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark DAPolicyManagerDelegate methods

- (void)policyManager:(DAPolicyManager *)policyManager didSavePolicy:(DAPolicyBase *)savedPolicy {
	
	[savingHUD dismiss];
	
	DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] init];
	actionResult.actionType = kDAActionSavePolicy;	
	actionResult.resultType = kDAResultSuccess;
	actionResult.actionParameters = automakerPolicy.policyID;
	
	[DAAccessLog saveAccessLog:actionResult];
	
	if ([delegate respondsToSelector:@selector(automakerPolicyItemViewController:didSavePolicy:)])
		[delegate automakerPolicyItemViewController:self didSavePolicy:self.automakerPolicy];
}

- (void)policyManager:(DAPolicyManager *)policyManager savePolicyDidFailWithErrorMessage:(NSString *)errorMessage {
	
	[savingHUD dismiss];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:@"Não foi possível salvar a apólice" 
														 message:errorMessage 
														delegate:nil 
											   cancelButtonTitle:nil 
											   otherButtonTitles:@"OK", nil];
	[errorAlert show];
}




@end

