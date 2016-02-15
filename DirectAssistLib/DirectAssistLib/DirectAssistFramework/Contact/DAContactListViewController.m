//
//  DAContactListViewController.m
//  DirectAssistLiberty
//
//  Created by Ricardo Ramos on 7/16/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAContactListViewController.h"
#import "DAContact.h"
#import "DAAddress.h"

@implementation DAContactListViewController

@synthesize delegate, searchReferenceCoordinate;

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
	
    if (nil == contactsList)
		contactsList = [[NSArray alloc] init];
}



- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];


}





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
    return [contactsList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Set up the cell...
	DAContact *contact = [contactsList objectAtIndex:indexPath.row];

	cell.textLabel.adjustsFontSizeToFitWidth = YES;
	cell.textLabel.text = [contact.name wordCapitalizedString];
	
	CLLocation *sourceLocation = [[CLLocation alloc] initWithLatitude:searchReferenceCoordinate.latitude 
															longitude:searchReferenceCoordinate.longitude];
	CLLocation *destinationLocation = [[CLLocation alloc] initWithLatitude:contact.address.coordinate.latitude 
																 longitude:contact.address.coordinate.longitude];
	double distance = [sourceLocation distanceFromLocation:destinationLocation];
	
	
	cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
	cell.detailTextLabel.text = [NSString stringWithFormat:@"%0.1f km", (distance / 1000)];
	cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if ([delegate respondsToSelector:@selector(contactListViewController:didSelectContact:)]) {
	
		DAContact *contact = [contactsList objectAtIndex:indexPath.row];
		[delegate contactListViewController:self didSelectContact:contact];
	
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
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

- (void)showContacts:(NSArray *)contacts {
	contactsList = contacts;
	[self.tableView reloadData];
}



@end

