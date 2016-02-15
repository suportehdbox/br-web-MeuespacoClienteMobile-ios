//
//  DAAddressViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/8/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAddressViewController.h"
#import "DAAddress.h"
#import "DARegularTextFieldCell.h"

@implementation DAAddressViewController

@synthesize address, delegate;

enum kDAAddressViewRows {
	kDAAddressViewRowStreetName = 0,
	kDAAddressViewRowHouseNumber,
	kDAAddressViewRowDistrict,
	kDAAddressViewRowCity,
	kDAAddressViewRowState,
	TOTAL_ROWS
};

- (id)init {
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	if (self = [super initWithNibName:@"DAAddressViewController" bundle:bundle]) {
	}
	return self;
}

- (id)initWithAddress:(DAAddress *)itemAddress {
	
	if (self = [self init]) {
		
		self.address = itemAddress;
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"Address", nil);
	
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];

    UIBarButtonItem *saveButton = [Utility addCustomButtonNavigationBar:self action:@selector(saveButton_clicked) imageName:@"44-assistenciares-localref-btn-salvar"];
	self.navigationItem.rightBarButtonItem = saveButton;
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
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return TOTAL_ROWS;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.row == kDAAddressViewRowHouseNumber) {
		
		static NSString *CellIdentifier = @"NumberCell";
		
		houseNumberCell = (DARegularTextFieldCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (houseNumberCell == nil) {
			houseNumberCell = [[DARegularTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		houseNumberCell.textLabel.text = [DALocalizedString(@"StreetNumber", nil) lowercaseString];
		houseNumberCell.textLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
		houseNumberCell.textField.text = address.houseNumber;
		houseNumberCell.textField.keyboardType = UIKeyboardTypeNumberPad;
		[houseNumberCell.textField becomeFirstResponder];
		
		return houseNumberCell;
	}
	else {
	
		static NSString *CellIdentifier = @"Cell";
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:CellIdentifier];
		}
		
		cell.selectionStyle = UITableViewCellSelectionStyleNone;
		cell.textLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
		
		switch (indexPath.row) {
			case kDAAddressViewRowStreetName:
				cell.textLabel.text = [DALocalizedString(@"StreetName", nil) lowercaseString];
				cell.detailTextLabel.text = address.streetName;
				break;
			case kDAAddressViewRowDistrict:
				cell.textLabel.text = [DALocalizedString(@"District", nil) lowercaseString];
				cell.detailTextLabel.text = address.district;
				break;
			case kDAAddressViewRowCity:
				cell.textLabel.text = [DALocalizedString(@"City", nil) lowercaseString];
				cell.detailTextLabel.text = address.city;
				break;
			case kDAAddressViewRowState:
				cell.textLabel.text = [DALocalizedString(@"State", nil) lowercaseString];
				cell.detailTextLabel.text = address.state;
				break;
		}
		
		return cell;
	}
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // Navigation logic may go here. Create and push another view controller.
	// AnotherViewController *anotherViewController = [[AnotherViewController alloc] initWithNibName:@"AnotherView" bundle:nil];
	// [self.navigationController pushViewController:anotherViewController];
	// [anotherViewController release];
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

#pragma mark BarButton methods

- (void)saveButton_clicked {

	self.address.houseNumber = houseNumberCell.textField.text;
	
	if ([delegate respondsToSelector:@selector(addressViewController:didSaveAddress:)]) 
		[delegate addressViewController:self didSaveAddress:self.address];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end

