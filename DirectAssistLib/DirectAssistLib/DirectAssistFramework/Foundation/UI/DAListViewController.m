//
//  DAListViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAListViewController.h"
#import "DACallMaker.h"

@implementation DAListViewController

@synthesize listItems, tag, delegate, headerText, showCallToAssistanceOption, preselectedItem;
@synthesize assistanceType;

- (id)init {

	if (self = [super initWithNibName:@"DAListViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
	}
	return self;
}

- (id)initWithListItems:(NSArray *)items title:(NSString *)viewTitle tag:(NSInteger)viewTag {

	if (self = [self init]) {
	
		self.listItems = items;
		self.title = viewTitle;
		self.tag = viewTag;
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

    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
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
    return 1 + (showCallToAssistanceOption ? 1 : 0);
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == 0 ? [self.listItems count] : 1);
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
	
	cell.textLabel.textColor = [[DAConfiguration settings] applicationClient].defaultColor;
    
	if (indexPath.section == 0) {
		
		DAKeyValue *item = (DAKeyValue *)[self.listItems objectAtIndex:indexPath.row];
		cell.textLabel.text = item.value;
		
		if (self.preselectedItem == item)
			cell.accessoryType = UITableViewCellAccessoryCheckmark;
	}
	else {
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"28_assistencia-nova-servico-btn-ligar.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:backgroundImageView];
	}

    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (indexPath.section == 0) {
   
		DAKeyValue *item = (DAKeyValue *)[self.listItems objectAtIndex:indexPath.row];
	
		if ([delegate respondsToSelector:@selector(listViewController:didSelectItem:)])
			[delegate listViewController:self didSelectItem:item];
	}
	else {
		
		DACallMaker *callMaker = [[DACallMaker alloc] init];
		[callMaker callToClientPhoneNumber:self.view assistanceType:assistanceType];
	}

}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	
	return (section == 0 ? headerText : DALocalizedString(@"CallForAnotherService", nil));
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

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}



@end

