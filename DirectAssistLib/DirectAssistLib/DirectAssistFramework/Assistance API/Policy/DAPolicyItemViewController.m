//
//  DAPolicyItemViewController.m
//  DirectAssistItau
//
//  Created by Ricardo Ramos on 8/12/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAPolicyItemViewController.h"
#import "DAPropertyPolicy.h"
#import "DAAutomotivePolicy.h"
#import "DAAddress.h"
#import "DALocationCell.h"

@implementation DAPolicyItemViewController

@synthesize policy, assistanceType, delegate;

// Automotive rows
enum {
	kDAAutomotivePolicyIDRow = 0,
	kDAAutomotiveUserNameRow,
	kDAAutomotiveVehicleModelRow,
	kDAAutomotiveVehiclePlateRow,
	kDAAutomotiveVehicleYearRow,
	kDAAutomotiveTotalRows
};

// Automaker rows
enum {
	kDAAutomakerPolicyIDRow = 0,
	kDAAutomakerUserNameRow,
	kDAAutomakerVehicleModelRow,
	kDAAutomakerVehicleChassisRow,
	kDAAutomakerTotalRows
};

// Property rows
enum {
	kDAPropertyPolicyIDRow = 0,
	kDAPropertyUserNameRow,
	kDAPropertyAddressRow,
//	kDAPropertyAddressDetailRow,
	kDAPropertyTotalRows
};

enum {
	kDAPolicyInfoSection = 0,
	kDASavePolicySection,
	kDATotalSections
};

- (id)init {

    if (self = [super initWithNibName:@"DAPolicyItemViewController" bundle:[NSBundle bundleForClass:[self class]]]) {

		savingHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Saving...", nil)];
    }
    return self;
}


- (id)initWithPolicy:(DAPolicyBase *)policyItem {

	if (self = [self init]) {
    
		self.policy = policyItem;
	}
    return self;	
}


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"Policy", nil);
    
    Client *client = [[Client alloc] init];
    if (client.clientID == 173) {
        isHeliar = YES;
    } else {
        isHeliar = NO;
    }
    
    UIBarButtonItem *cancelButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnCancel:) imageName:@"btn-cancelar.png"];
    self.navigationItem.leftBarButtonItem = cancelButton;
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[savingHUD dismiss];
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
    return kDATotalSections;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
	NSInteger numRows;
	
	if (section == kDAPolicyInfoSection) {
		
        if (isHeliar == NO) {
        
            switch (assistanceType) {
                case kDAAssistanceTypeAutomotive:
                    numRows = kDAAutomotiveTotalRows;
                    break;
                case kDAAssistanceTypeAutomaker:
                    numRows = kDAAutomakerTotalRows;
                    break;
                case kDAAssistanceTypeProperty:
                    numRows = kDAPropertyTotalRows;
                    break;
            }
            
        } else {
            numRows = 2;
        }
             
	} else {
		numRows = 1;
	}

	return numRows;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == kDAPolicyInfoSection) {

		static NSString *CellIdentifier = @"viewCell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
		}	
		cell.textLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
		
		if (assistanceType == kDAAssistanceTypeAutomotive) {
			
            if (isHeliar == NO) {
            
                switch (indexPath.row) {
                    case kDAAutomotivePolicyIDRow:
                        cell.textLabel.text = [DALocalizedString(@"Policy", nil) lowercaseString];
                        cell.detailTextLabel.text = self.policy.policyID;
                        break;
                    case kDAAutomotiveUserNameRow:
                        cell.textLabel.text = [DALocalizedString(@"Name", nil) lowercaseString];
                        cell.detailTextLabel.text = [self.policy.customerName wordCapitalizedString];
                        break;
                    case kDAAutomotiveVehicleModelRow:
                        cell.textLabel.text = [DALocalizedString(@"VehicleModel", nil) lowercaseString];
                        cell.detailTextLabel.text = [(DAAutomotivePolicy *)self.policy vehicleModel];
                        break;
                    case kDAAutomotiveVehiclePlateRow:
                        cell.textLabel.text = [DALocalizedString(@"VehicleLicense", nil) lowercaseString];
                        cell.detailTextLabel.text = [(DAAutomotivePolicy *)self.policy vehiclePlate];
                        break;
                    case kDAAutomotiveVehicleYearRow:
                        cell.textLabel.text = [DALocalizedString(@"VehicleYear", nil) lowercaseString];
                        cell.detailTextLabel.text = [(DAAutomotivePolicy *)self.policy vehicleYear];
                        break;
                    default:
                        break;
                }
            } else {
                switch (indexPath.row) {
                    case 0:
                        cell.textLabel.text = [DALocalizedString(@"Policy", nil) lowercaseString];
                        cell.detailTextLabel.text = self.policy.policyID;
                        break;
                    case 1:
                        cell.textLabel.text = [DALocalizedString(@"Name", nil) lowercaseString];
                        cell.detailTextLabel.text = [self.policy.customerName wordCapitalizedString];
                        break;
                }
            }
		}
		else if (assistanceType == kDAAssistanceTypeAutomaker) {
			
			switch (indexPath.row) {
				case kDAAutomakerPolicyIDRow:
					cell.textLabel.text = [DALocalizedString(@"Policy", nil) lowercaseString];
					cell.detailTextLabel.text = self.policy.policyID;
					break;
				case kDAAutomakerUserNameRow:
					cell.textLabel.text = [DALocalizedString(@"Name", nil) lowercaseString];
					cell.detailTextLabel.text = [self.policy.customerName wordCapitalizedString];
					break;
				case kDAAutomakerVehicleModelRow:
					cell.textLabel.text = [DALocalizedString(@"VehicleModel", nil) lowercaseString];
					cell.detailTextLabel.text = [(DAAutomotivePolicy *)self.policy vehicleModel];
					break;
				case kDAAutomakerVehicleChassisRow:
					cell.textLabel.text = [DALocalizedString(@"VehicleChassis", nil) lowercaseString];
					cell.detailTextLabel.text = [(DAAutomotivePolicy *)self.policy vehicleChassis];
					break;
				default:
					break;
			}		
		}
		else {

			switch (indexPath.row) {
				case kDAPropertyPolicyIDRow:
					cell.textLabel.text = [DALocalizedString(@"Policy", nil) lowercaseString];
					cell.detailTextLabel.adjustsFontSizeToFitWidth = YES;
					cell.detailTextLabel.text = self.policy.policyID;
					break;
				case kDAPropertyUserNameRow:
					cell.textLabel.text = [DALocalizedString(@"Name", nil) lowercaseString];
					cell.detailTextLabel.text = [self.policy.customerName wordCapitalizedString];
					break;
				case kDAPropertyAddressRow: {

					static NSString *CellIdentifier = @"Location";
					
					locationCell = (DALocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
					if (locationCell == nil) {
						[[NSBundle bundleForClass:[self class]] loadNibNamed:@"DALocationCell" owner:self options:nil];
					}	
					
					[locationCell setFontColor:[DAConfiguration settings].applicationClient.defaultColor];
					[locationCell setCellDataWithAddress:[(DAPropertyPolicy *)self.policy address]];
					
					locationCell.selectionStyle = UITableViewCellSelectionStyleNone;
					return locationCell;
				}
				default:
					break;
			}
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
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"26_assistencia-novaescolheradd-btn-add.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:backgroundImageView];
        
		return cell;
	}

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return (indexPath.section == kDAPolicyInfoSection &&
			indexPath.row == kDAPropertyAddressRow &&
			assistanceType == kDAAssistanceTypeProperty ? 100 : 44);
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == kDASavePolicySection) {
		
		if (![Utility hasInternet]) {			
			[Utility showNoInternetWarning];
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
			return;
		}
		
		[savingHUD showWithNetworkActivityStatus];
		
		DAPolicyManager *policyManager = [[DAPolicyManager alloc] init];
		[policyManager setDelegate:self];
		[policyManager savePolicy:self.policy];
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

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark DAPolicyManagerDelegate methods 

- (void)policyManager:(DAPolicyManager *)policyManager didSavePolicy:(DAPolicyBase *)savedPolicy {

	if (assistanceType == kDAAssistanceTypeAutomotive) {
		if ([DAConfiguration settings].applicationClient.dynamicFooter) {
		
			NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
			[userDefaults setInteger:savedPolicy.groupID forKey:FOOTER_GROUP_ID_KEY];
			[[NSNotificationCenter defaultCenter] postNotificationName:FOOTER_GROUP_ID_CHANGE_NOTIFICATION object:self];	
		}
	}
	if ([delegate respondsToSelector:@selector(policyItemViewController:didSavePolicy:)])
		[delegate policyItemViewController:self didSavePolicy:savedPolicy];
}




@end

