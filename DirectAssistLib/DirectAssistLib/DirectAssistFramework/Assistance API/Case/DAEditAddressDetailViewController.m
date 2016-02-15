//
//  EditAddressDetailViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 04/05/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DAEditAddressDetailViewController.h"
#import "DAEditAddressDetailCell.h"

@implementation DAEditAddressDetailViewController

@synthesize delegate, addressDetailText;

- (void)viewDidLoad {
    [super viewDidLoad];

	self.title = DALocalizedString(@"AddressDetail", nil);
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
    
    UIBarButtonItem *saveButton = [Utility addCustomButtonNavigationBar:self action:@selector(btnSave:) imageName:@"44-assistenciares-localref-btn-salvar.png"];
    self.navigationItem.rightBarButtonItem = saveButton;
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

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

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnSave:(id)sender
{
    DAEditAddressDetailCell *cell = (DAEditAddressDetailCell *) [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    
	if ([delegate respondsToSelector:@selector(editAddressDetailViewController:didEditAddressDetail:)])
		[delegate editAddressDetailViewController:self didEditAddressDetail:cell.txtAddressDetail.text];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"EditAddressDetail";
    
    addressDetailCell = (DAEditAddressDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
	if (addressDetailCell == nil) {
		[[NSBundle bundleForClass:[self class]] loadNibNamed:@"DAEditAddressDetailCell" owner:self options:nil];
	}	
	
	addressDetailCell.txtAddressDetail.text = addressDetailText;
	[addressDetailCell.txtAddressDetail becomeFirstResponder];
	addressDetailCell.txtAddressDetail.delegate = self;
    return addressDetailCell;
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
	return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 150;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
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




@end

