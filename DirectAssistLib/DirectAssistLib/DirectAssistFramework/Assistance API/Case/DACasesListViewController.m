//
//  DACasesListViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DACasesListViewController.h"
#import "DAFileBase.h"
#import "DACaseViewController.h"
#import "GoogleAnalyticsManager.h"

@implementation DACasesListViewController

@synthesize assistanceType;

- (id)init {

	if (self = [super initWithNibName:@"DACasesListViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
	}
	return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = DALocalizedString(@"MyFiles", nil);
    
    [GoogleAnalyticsManager send:@"Assistência Automotiva: Consulta"];
    NSLog(@"Assistência Automotiva: Consulta");
	
	UIEdgeInsets edge;
	edge.bottom = 44;
	self.tableView.contentInset = edge;
	self.tableView.scrollIndicatorInsets = edge;	

	loadingHUD = [[DAProgressHUD alloc] initWithLabel:DALocalizedString(@"Loading...", nil)];
	[loadingHUD showWithNetworkActivityStatus];
	
	casesList = [[NSArray alloc] init];
	
	DACasesListWS *casesListWS = [[DACasesListWS alloc] init];
	[casesListWS setDelegate:self];
	[casesListWS listCasesWithAssistanceType:assistanceType];
    
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

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[loadingHUD dismiss];
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

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [casesList count];
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"File";
    
    fileCell = (DACaseCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (fileCell == nil) {
        [[NSBundle bundleForClass:[self class]] loadNibNamed:@"DACaseCell" owner:self options:nil];
    }
    
    // Set up the cell...
	DAFileBase* caseObj = [casesList objectAtIndex:indexPath.row];
	[fileCell setCellDataWithFileNumber:caseObj.fileNumber withFileDate:caseObj.creationDateString];
	
    return fileCell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	if (![Utility hasInternet]) {
		[Utility showNoInternetWarning];
		[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		return;
	}
	
	DACaseViewController *fileViewController = [[DACaseViewController alloc] initWithNibName:@"DACaseViewController" bundle:[NSBundle bundleForClass:[self class]]];
	
	fileViewController.selectedFile = [casesList objectAtIndex:indexPath.row];
	[self.navigationController pushViewController:fileViewController animated:YES];
}


#pragma mark DACasesListWSDelegate methods

- (void)casesList:(DACasesListWS *)casesListWS didListCases:(NSArray *)cases {

	[loadingHUD dismiss];
	
	casesList = cases;
	[self.tableView reloadData];
}

- (void)casesList:(DACasesListWS *)casesList didFailWithError:(NSString *)errorMessage {

	[loadingHUD dismiss];
	
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"CantLoadCases", nil) 
														 message:errorMessage
														delegate:self 
											   cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
}

#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}



@end

