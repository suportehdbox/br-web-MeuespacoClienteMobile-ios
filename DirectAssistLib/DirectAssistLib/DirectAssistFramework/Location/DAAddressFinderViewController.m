//
//  DAAddressFinderViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAddressFinderViewController.h"
#import "DAAddress.h"
#import "DAGeocoder.h"
#import "DAProgressHUD.h"

@implementation DAAddressFinderViewController

@synthesize delegate;

- (id)init {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	if (self = [super initWithNibName:@"DAAddressFinderViewController" bundle:bundle]) {
	}
	return self;
}

/*
- (id)initWithStyle:(UITableViewStyle)style {
    // Override initWithStyle: if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
    if (self = [super initWithStyle:style]) {
    }
    return self;
}
*/


- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"Search", nil);
	
	progressHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Searching...", nil)];
    searchResult = [[NSArray alloc] init];
	
	[searchBar setScopeButtonTitles:[NSArray arrayWithObjects:DALocalizedString(@"Zipcode", nil), DALocalizedString(@"StreetAndCity", nil), nil]];
	
	[self setScopeDisplay:0]; // Zipcode is default
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnCancel:)];
}


/*
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}
*/

//- (void)viewDidAppear:(BOOL)animated {
//    [super viewDidAppear:animated];
//	[searchBar becomeFirstResponder];
//}
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

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [searchResult count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	DAAddress *address = [searchResult objectAtIndex:indexPath.row];
	cell.textLabel.text = [NSString stringWithFormat:@"%@ - %@", address.streetName, address.district];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ - %@", address.city, address.state, address.zipcode];
	
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if ([delegate respondsToSelector:@selector(addressFinderViewController:didSelectAddress:)]) {
		DAAddress *selectedAddress = [searchResult objectAtIndex:indexPath.row];
		[delegate addressFinderViewController:self didSelectAddress:selectedAddress];
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

- (void)setAddressSearchType:(kDAAddressSearchType)searchType {
	
	[self setScopeDisplay:searchType];
}

-(kDAAddressSearchType)addressSearchType {
	
	return searchBar.selectedScopeButtonIndex;
}

#pragma mark UISearchBarDelegate methods

- (void)searchBarSearchButtonClicked:(UISearchBar *)theSearchBar {
	
	DAGeocoder *geocoder = [[DAGeocoder alloc] init];
	geocoder.delegate = self;
	if (searchBar.selectedScopeButtonIndex == 0) {
		[searchBar resignFirstResponder];
		[progressHUD show];
		[geocoder searchWithZipcode:searchBar.text];
	}
	else {
		NSArray *searchKeys = [searchBar.text componentsSeparatedByString:@","];
		if ([searchKeys count] > 1) {
			
			[searchBar resignFirstResponder];
			[progressHUD show];
			[geocoder searchWithStreet:[searchKeys objectAtIndex:0] city:[searchKeys objectAtIndex:1]];
		}
		else {
		
			UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil 
															message:DALocalizedString(@"FillGeocodeInfo", nil) 
														   delegate:nil 
												  cancelButtonTitle:nil 
												  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
			[alert show];
		}
	}
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)theSearchBar {
	[searchBar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)theSearchBar selectedScopeButtonIndexDidChange:(NSInteger)selectedScope {
	[self setScopeDisplay:selectedScope];
}

#pragma mark DAGeocoderDelegate methods

- (void)geocoder:(DAGeocoder *)geocoder didFindAddresses:(NSArray *)addresses {

	if ([addresses count] == 0) {
		UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
														message:DALocalizedString(@"AddressNotFound", nil)
													   delegate:self
											  cancelButtonTitle:nil
											  otherButtonTitles:DALocalizedString(@"OK", nil), nil];
		[alert show];
    } else {
        [progressHUD dismissWithClickedButtonIndex:0 animated:NO];
        searchResult = addresses;
        [self.tableView reloadData];
    }
}

- (void)geocoder:(DAGeocoder *)geocoder didFailWithError:(NSError *)error {

//	[progressHUD dismiss];
//	ShowErrorAlert(error, DALocalizedString(@"CantGeocodeAddress", nil), nil);
}

- (void)geocoderDidFailNoInternetConnection:(DAGeocoder *)geocoder {

}

#pragma mark - UIAlertDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [progressHUD dismissWithClickedButtonIndex:0 animated:NO];    
}

#pragma mark DAAddressFinderViewController methods

- (void)setScopeDisplay:(NSInteger)selectedScopeIndex {
	switch (selectedScopeIndex) {
		case 0: // Zipcode
			searchBar.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
			searchBar.placeholder = DALocalizedString(@"Zipcode", nil);
			break;
		default:
			searchBar.keyboardType = UIKeyboardTypeAlphabet;
			searchBar.placeholder = DALocalizedString(@"StreetAndCity", nil); //@"Rua, Cidade";
			break;
	}
}



@end

