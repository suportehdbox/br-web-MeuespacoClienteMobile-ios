//
//  DAAssistanceMenuViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DAAssistanceMenuViewController.h"
#import "DABannerCell.h"
#import "DANewCaseViewController.h"
#import "DACasesListViewController.h" 
#import "DADealersListViewController.h"
#import "DAAccreditedGaragesViewController.h"
#import "DACallMaker.h"

#define CELL_HEIGHT_BANNER 140
#define CELL_HEIGHT_DEFAULT 44

@implementation DAAssistanceMenuViewController

@synthesize assistanceType; 

enum DAAssistanceMenuSections {
    kDAServicesSection = 0,
    kDABannerSection,
    NUM_SECTIONS
};

- (id)initWithOptions:(NSArray *)menuOptions {

    if (self = [super initWithNibName:@"DAAssistanceMenuViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
		options = menuOptions;
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

	switch (assistanceType) {
		case kDAAssistanceTypeAutomotive:
		case kDAAssistanceTypeAutomaker:
			self.navigationItem.title = DALocalizedString(@"AutomotiveAssistance", nil);
			break;
		case kDAAssistanceTypeProperty:
			self.navigationItem.title = DALocalizedString(@"PropertyAssistance", nil);
			//self.navigationItem.title = @"Assistencia Empresarial";
            break;
		default:
			break;
	}
    
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
    return NUM_SECTIONS;
}


// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return (section == kDAServicesSection) ? [options count] : 1;
}


// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	if (indexPath.section == kDAServicesSection) {
		
		static NSString *CellIdentifier = @"Cell";		
  		DAKeyValue *menuItem = (DAKeyValue *)[options objectAtIndex:indexPath.row];
		
		UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (cell == nil) {
			cell = [[UITableViewCell alloc] initWithFrame:CGRectZero reuseIdentifier:CellIdentifier];
            NSString *imageName = [NSString stringWithFormat:@"%@_%@.png", [self assistanceTypeTag], menuItem.key];
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
            cell.imageView.image = image;
		}
 		cell.textLabel.text = menuItem.value;
		
		return cell;
	} else if (indexPath.section == kDABannerSection) {
		
		static NSString *CellIdentifier = @"MainBanner";	
		
		banner = (DABannerCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
		if (banner == nil) {
			banner = [[DABannerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
		}
		
		// Set up the cell...
//		banner.bannerImageView.image = [UIImage imageNamed:@"Banner.png"];
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"Banner.jpg" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        banner.bannerImageView.image = image;
		return banner;
	}
	return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return (indexPath.section == kDAServicesSection) ? CELL_HEIGHT_DEFAULT: CELL_HEIGHT_BANNER;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

	
	// Temp
	/*
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Aviso de Prevenção" 
													message:@"Seu veículo está com 32000 km rodados. Verifique se a Correia Dentada está em boas condições" 
												   delegate:nil 
										  cancelButtonTitle:nil 
										  otherButtonTitles:@"OK", nil];
	[alert show];
	
	return;
	*/
	
	if (indexPath.section == kDAServicesSection) {
	
		DAKeyValue *menuItem = (DAKeyValue *)[options objectAtIndex:indexPath.row];

		if (menuItem.key == @"NewFile") {
			
			DANewCaseViewController *newCaseVC = [[DANewCaseViewController alloc] init];
			[newCaseVC setAssistanceType:self.assistanceType];
			[self.navigationController pushViewController:newCaseVC animated:YES];
		}
		else if (menuItem.key == @"MyFiles") {
		
			if (![Utility hasInternet]) {
				[Utility showNoInternetWarning];
				[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
				return;
			}
			
			DACasesListViewController *casesListVC = [[DACasesListViewController alloc] init];
			[casesListVC setAssistanceType:self.assistanceType];
			[self.navigationController pushViewController:casesListVC animated:YES];
		}
		else if (menuItem.key == @"MechanicNetwork") {
			
			if (![Utility hasInternet]) {			
				[Utility showNoInternetWarning];
				[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
				return;
			}
			
			if ([AppConfig sharedConfiguration].appClient.clientID == 173) {
				DADealersListViewController *dealersVC = [[DADealersListViewController alloc] init];
				[self.navigationController pushViewController:dealersVC animated:YES];
			}
			else {
				DAAccreditedGaragesViewController *garagesVC = [[DAAccreditedGaragesViewController alloc] init];
				[self.navigationController pushViewController:garagesVC animated:YES];
			}

		}
		else if (menuItem.key == @"DealersList") {
			
			if (![Utility hasInternet]) {			
				[Utility showNoInternetWarning];
				[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
				return;
			}
			//DAAccreditedGaragesViewController *dealersVC = [[DAAccreditedGaragesViewController alloc] init];
			//[self.navigationController pushViewController:dealersVC animated:YES];
			//[dealersVC release];
			
			DADealersListViewController *dealersVC = [[DADealersListViewController alloc] init];
			[self.navigationController pushViewController:dealersVC animated:YES];
		}
		else if (menuItem.key == @"Call") {
			
			[tableView deselectRowAtIndexPath:indexPath animated:YES];
			
			DACallMaker *callMaker = [[DACallMaker alloc] init];
//			[callMaker callToClientPhoneNumber:self.view assistanceType:self.assistanceType];
			[callMaker callToClientPhoneNumber:self.view];

		}
	}
	else if (indexPath.section == kDABannerSection) {
		[[UIApplication sharedApplication] openURL:[NSURL URLWithString:[DAConfiguration settings].applicationClient.bannerHomepage]];
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
- (NSString *)assistanceTypeTag {

	switch (assistanceType) {
		case kDAAssistanceTypeAutomotive:
			return @"AU";
			break;
		case kDAAssistanceTypeAutomaker:
			return @"AM";
			break;
		case kDAAssistanceTypeProperty:
			return @"PR";
			break;
		default:
			return @"AU";
			break;
	}
}



@end

