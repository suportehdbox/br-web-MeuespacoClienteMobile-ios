//
//  DAContactViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/10/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAContactItemViewController.h"
#import "DATextDetailCustomCell.h"
#import "DAContact.h"
#import "DAAddress.h"
#import "DAPhone.h"
#import "DACallMaker.h"
#import "DAGoogleMaps.h"
#import "DAUserLocation.h"
#import <AddressBookUI/AddressBookUI.h>

#define TABLE_SECTIONS 3
#define TABLE_ADDRESS_PHONE_SECTION 0
#define TABLE_DIRECTION_SECTION 1
#define TABLE_ADDCONTACT_SECTION 2
#define TABLE_ADDRESS_PHONE_ROWS 2
#define TABLE_ADDRESS_ROW 0
#define TABLE_PHONE_ROW 1

@implementation DAContactItemViewController

@synthesize contact;

- (id)initWithContact:(DAContact *)viewContact {
	return [self initWithContact:viewContact viewTitle:nil];
}

- (id)initWithContact:(DAContact *)viewContact viewTitle:(NSString *)viewTitle {
	if (self = [super initWithNibName:@"DAContactItemViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
		self.contact = viewContact;
		self.title = viewTitle;
	}
	return self;
}


- (void)viewDidLoad {
    [super viewDidLoad];

	newPersonVC = [[ABNewPersonViewController alloc] init];
	newPersonVC.newPersonViewDelegate = self;
	newPersonNavController = [[UINavigationController alloc] initWithRootViewController:newPersonVC];
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
/*
- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
}
*/
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
    return TABLE_SECTIONS;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == TABLE_ADDRESS_PHONE_SECTION ? TABLE_ADDRESS_PHONE_ROWS : 1);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	switch (indexPath.section) {
		case TABLE_ADDRESS_PHONE_SECTION: {
			if (indexPath.row == TABLE_ADDRESS_ROW) {
				static NSString *cellIdentifier = @"AddressCell";
				
				DATextDetailCustomCell *cell = (DATextDetailCustomCell *)[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
				if (cell == nil) {
					cell = [[DATextDetailCustomCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
				}
				// Set up the cell...
				cell.textLabel.text = [DALocalizedString(@"Address", nil) lowercaseString];
				cell.detailTextLabel.numberOfLines = 4;
				cell.detailTextLabel.lineBreakMode = UILineBreakModeWordWrap;
				cell.detailTextLabel.text = [contact.address fullAddress];
				cell.selectionStyle = UITableViewCellSelectionStyleNone;
				
				return cell;
			}
			else {
				static NSString *cellIdentifier = @"PhoneCell";
			
				UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
				if (cell == nil) {
					cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:cellIdentifier];
				}
				// Set up the cell...
				cell.textLabel.text = [DALocalizedString(@"Phone", nil) lowercaseString];
				cell.detailTextLabel.text = [contact.businessPhone stringFromPhoneNumber];
			
                NSBundle *bundle = [NSBundle bundleForClass:[self class]];
                UIImage *image = [UIImage imageNamed:@"Call.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
                
				UIImageView *callImgView = [[UIImageView alloc] initWithImage:image];
				cell.accessoryView = callImgView;
				
				return cell;		
			}
			break;
		}
		case TABLE_DIRECTION_SECTION: {
			static NSString *cellIdentifier = @"GetDirectionsCell";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
			// Set up the cell...
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.text = DALocalizedString(@"GetDirections", nil);
			
			return cell;		
			break;
		}
		case TABLE_ADDCONTACT_SECTION: {
			static NSString *cellIdentifier = @"AddContactCell";
			
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
			}
			// Set up the cell...
			cell.textLabel.textAlignment = UITextAlignmentCenter;
			cell.textLabel.text = DALocalizedString(@"AddToContacts", nil);
			
			return cell;		
			break;
		}
		default: {
	
			static NSString *CellIdentifier = @"Cell";
    
			UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
			if (cell == nil) {
				cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
			}
			// Set up the cell...
	
			return cell;
			break;
		}
	}
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section   // custom view for header. will be adjusted to default or specified header height
{
	
	if (section==0)
		return [self getHeader:[contact.name wordCapitalizedString] withButtonText:nil];

	return nil;
}

- (UIView *) getHeader:(NSString *)label withButtonText:(NSString *)buttonText {

	UIView *headerView = [[UIView alloc] initWithFrame:CGRectZero];

	UIImageView *iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"ContactPin.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
	iconImg.image = image;
	iconImg.contentMode = UIViewContentModeScaleAspectFit;
	[headerView addSubview:iconImg];
	
	UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, 220, 60)];
	titleLabel.opaque = YES;
	titleLabel.backgroundColor=[UIColor clearColor];
	titleLabel.numberOfLines = 2;
	titleLabel.font = [UIFont systemFontOfSize:18];
	titleLabel.text = label;
	[headerView addSubview:titleLabel];

	return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	//return 80;
    return (section == TABLE_ADDRESS_PHONE_SECTION ? 80 : 10);
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == TABLE_ADDRESS_PHONE_SECTION && indexPath.row == TABLE_ADDRESS_ROW ? 104 : 44);
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
 	switch (indexPath.section) {
		case TABLE_ADDRESS_PHONE_SECTION: {
			if (indexPath.row == TABLE_PHONE_ROW)
				[DACallMaker callToPhone:contact.businessPhone];
			break;
		}
		case TABLE_DIRECTION_SECTION: {
			CLLocationCoordinate2D coordinate = [DAUserLocation currentLocation].coordinate;
			[DAGoogleMaps getDirectionsFromCoordinate:coordinate toAddress:contact.address];
			break;
		}
		case TABLE_ADDCONTACT_SECTION: {
			
			ABRecordRef person = ABPersonCreate();

			ABRecordSetValue(person, kABPersonFirstNameProperty, (__bridge CFTypeRef)(contact.name), nil);
	
			ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
			ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)([contact.businessPhone stringFromPhoneNumber]), kABWorkLabel, NULL);        
			ABRecordSetValue(person, kABPersonPhoneProperty, multiPhone, nil);

			// Adding the Address property
			ABMutableMultiValueRef multiAddress = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
			NSMutableDictionary *addressDictionary = [[NSMutableDictionary alloc] init];
			[addressDictionary setObject:contact.address.streetName forKey:(NSString *) kABPersonAddressStreetKey];
			[addressDictionary setObject:contact.address.city forKey:(NSString *)kABPersonAddressCityKey];
			[addressDictionary setObject:contact.address.state forKey:(NSString *)kABPersonAddressStateKey];
			ABMultiValueAddValueAndLabel(multiAddress, (__bridge CFTypeRef)(addressDictionary), kABWorkLabel, NULL);
			ABRecordSetValue(person, kABPersonAddressProperty, multiAddress,nil);
			CFRelease(multiAddress);
						
			newPersonVC.displayedPerson = person;

			[self presentModalViewController:newPersonNavController animated:YES];
			 
			CFRelease(person);													
		}
		default :
			break;
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

#pragma mark ABNewPersonViewControllerDelegate methods

- (void)newPersonViewController:(ABNewPersonViewController *)newPersonViewController didCompleteWithNewPerson:(ABRecordRef)person {

	[self dismissModalViewControllerAnimated:YES];
}



@end

