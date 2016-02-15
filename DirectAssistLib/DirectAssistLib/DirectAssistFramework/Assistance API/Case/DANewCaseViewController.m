//
//  NewCaseViewController.m
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import "DANewCaseViewController.h"
#import "DALocationCell.h"
#import "DAAddressDetailCell.h"
#import "DAAutomotiveFile.h"
#import "DAUserPhone.h"
#import "DAWebServiceActionResult.h"
#import "DAAccessLog.h"
#import "DAFileBase.h"
#import "DAPropertyPolicy.h"
#import "DAAutomotivePolicy.h"
#import "DASharedManager.h"
#import "GoogleAnalyticsManager.h"

#define PROGRESS_BAR	999

@interface DANewCaseViewController (PrivateMethods)

- (void)dismissProgressBarPanel;
- (void)scheduleQualitySurveyWithFileNumber:(NSInteger)fileNumber;

@end

@implementation DANewCaseViewController

enum {
	kDANewCaseFieldPolicyKey = 0,
	kDANewCaseFieldCause = 1,
	kDANewCaseFieldProblem = 2,
	kDANewCaseFieldService = 3,
	kDANewCaseFieldLocation = 4,
	kDANewCaseFieldAddressDetail = 5,
	kDANewCaseFieldSchedule = 6,
	TOTAL_ROWS = 7
};

@synthesize assistanceType;


- (id)init {

    if (self = [super initWithNibName:@"DANewCaseViewController" bundle:[NSBundle bundleForClass:[self class]]]) {
    }
    return self;
}



- (void)viewDidLoad {
    [super viewDidLoad];

	self.navigationItem.title = DALocalizedString(@"NewCase", nil);
    
    [GoogleAnalyticsManager send:@"Assistência Automotiva"];
    NSLog(@"Assistência Automotiva");

    Client *client = [[Client alloc] init];

    if (client.clientID == 173) {
    
        selectedCause = [[DAKeyValue alloc] initWithKey:@"31" withValue:DALocalizedString(@"BreakDown", nil) withTag:@""];
        
        hasProblem = YES;
        hasCaseSelected = YES;
        
    } else {
        hasCaseSelected = NO;
    }
    
	if (assistanceType == kDAAssistanceTypeProperty)
		hasSchedule = YES;
	
	//[self makeToolbar];
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnCancel:)];

}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"DirectAssist" message:@"Você deseja responder a pesquisa de qualidade referente ao atendimento" delegate:self cancelButtonTitle:@"Não" otherButtonTitles:@"Sim",nil];
	[alert show];
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

- (void)setPolicyKey:(NSString *)thePolicyKey {
	policyKey = thePolicyKey;
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0)
        return TOTAL_ROWS - (hasProblem ? 0 : 1) - (hasSchedule ? 0 : 1);
    else
        return 1;
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {
        
        static NSString *value2CellIdentifier = @"value2CellIdentifier";
		
        if (indexPath.row == kDANewCaseFieldPolicyKey) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:value2CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:value2CellIdentifier];
            }
            
            switch (assistanceType) {
                case kDAAssistanceTypeAutomotive:
                case kDAAssistanceTypeAutomaker:
                    cell.textLabel.text = [DALocalizedString(@"Vehicle", nil) lowercaseString];
                    break;
                case kDAAssistanceTypeProperty:
                    cell.textLabel.text = [DALocalizedString(@"Policy", nil) lowercaseString];
                    break;
                default:
                    break;
            }
            
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = policyKey;
            cell.detailTextLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
            
            return cell;
        }
        else if (indexPath.row == kDANewCaseFieldCause) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:value2CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:value2CellIdentifier];
            }
            
            cell.textLabel.text = [DALocalizedString(@"Cause", nil) lowercaseString];
            cell.textLabel.textColor = [UIColor blackColor];
            
            if (hasCaseSelected == NO) {
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            } else {
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
            
            cell.detailTextLabel.text = selectedCause.value;
            cell.detailTextLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
            
            return cell;
        }
        else if (indexPath.row == kDANewCaseFieldProblem && hasProblem) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:value2CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:value2CellIdentifier];
            }
            
            cell.textLabel.text = [DALocalizedString(@"Problem", nil) lowercaseString];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = selectedProblem.value;
            cell.detailTextLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
            
            return cell;
        }
        else if ((indexPath.row == kDANewCaseFieldService && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldService && !hasProblem)) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:value2CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:value2CellIdentifier];
            }
            
            cell.textLabel.text = [DALocalizedString(@"Service", nil) lowercaseString];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.text = selectedService.value;
            cell.detailTextLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
            
            return cell;
        }
        else if ((indexPath.row == kDANewCaseFieldLocation && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldLocation && !hasProblem)) {
            static NSString *CellIdentifier = @"Location";
            
            locationCell = (DALocationCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (locationCell == nil) {
                [[NSBundle bundleForClass:[self class]] loadNibNamed:@"DALocationCell" owner:self options:nil];
            }
            
            [locationCell setFontColor:[UIColor blackColor]];
            [locationCell setCellDataWithAddress:selectedAddress];
            
            if (self.assistanceType != kDAAssistanceTypeProperty) {
                locationCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                locationCell.selectionStyle = UITableViewCellSelectionStyleBlue;
            }
            
            return locationCell;
        }
        else if ((indexPath.row == kDANewCaseFieldAddressDetail && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldAddressDetail && !hasProblem)) {
            
            static NSString *CellIdentifier = @"AddressDetail";
            
            addressDetailCell = (DAAddressDetailCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (addressDetailCell == nil) {
                [[NSBundle bundleForClass:[self class]] loadNibNamed:@"DAAddressDetailCell" owner:self options:nil];
            }
            
            [addressDetailCell setFontColor:[UIColor blackColor]];
            [addressDetailCell setCellDataWithText:selectedAddressDetail];
            
            return addressDetailCell;
        }
        else if ((indexPath.row == kDANewCaseFieldSchedule && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldSchedule && !hasProblem)) {
            
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:value2CellIdentifier];
            
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:value2CellIdentifier];
            }
            
            cell.textLabel.text = [DALocalizedString(@"Schedule", nil) lowercaseString];
            cell.textLabel.textColor = [UIColor blackColor];
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            cell.detailTextLabel.textColor = [DAConfiguration settings].applicationClient.defaultColor;
            
            if (scheduleBeginDate) {
                
                NSDateFormatter *scheduleDateFormat = [[NSDateFormatter alloc] init];
                [scheduleDateFormat setDateFormat:@"dd/MMM"];
                
                NSDateFormatter *scheduleHourFormat = [[NSDateFormatter alloc] init];
                [scheduleHourFormat setDateFormat:@"HH:mm"];
                
                if (!scheduleEndDate) {
                    cell.detailTextLabel.text = [scheduleDateFormat stringFromDate:scheduleBeginDate];
                }
                else {
                    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ %@ %@ %@ %@",
                                                 [scheduleDateFormat stringFromDate:scheduleBeginDate],
                                                 [DALocalizedString(@"Between", nil) lowercaseString],
                                                 [scheduleHourFormat stringFromDate:scheduleBeginDate],
                                                 [DALocalizedString(@"And", nil) lowercaseString],
                                                 [scheduleHourFormat stringFromDate:scheduleEndDate]];
                }
            }
            
            return cell;
        }
        
    } else {
        
        static NSString *value2CellIdentifier = @"cellIdentifierSendButton";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:value2CellIdentifier];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:value2CellIdentifier];
        }
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"21_assistencia-nova-btn-enviar.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        [backgroundImageView setContentMode:UIViewContentModeScaleAspectFit];
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell setBackgroundView:backgroundImageView];
        
        return cell;
    }
    
    return nil;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	CGFloat rowHeight;
	
    if (indexPath.section == 0) {
        
        if (indexPath.row == kDANewCaseFieldPolicyKey)
            rowHeight = 38;
        
        else if (indexPath.row == kDANewCaseFieldCause)
            rowHeight = 38;
		
        else if (indexPath.row == kDANewCaseFieldProblem && hasProblem)
            rowHeight = 38;
		
        else if ((indexPath.row == kDANewCaseFieldService && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldService && !hasProblem))
            rowHeight = 38;
		
        else if ((indexPath.row == kDANewCaseFieldLocation && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldLocation && !hasProblem))
            rowHeight = 100;
		
        else if ((indexPath.row == kDANewCaseFieldAddressDetail && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldAddressDetail && !hasProblem))
            rowHeight = 50;
		
        else if ((indexPath.row == kDANewCaseFieldSchedule && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldSchedule && !hasProblem)) 
            rowHeight = 38;
        
    } else {
        rowHeight = 46;
    }

	return rowHeight;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];    
    if (indexPath.section == 0) {
        if (indexPath.row == kDANewCaseFieldPolicyKey) {
        
            if (![Utility hasInternet]) {			
                [Utility showNoInternetWarning];
                return;
            }
            
            DAPolicyListViewController *policyListViewController = [[DAPolicyListViewController alloc] init];;
            policyListViewController.delegate = self;
            policyListViewController.assistanceType = self.assistanceType;

            [self.navigationController pushViewController:policyListViewController animated:YES];
        }
        else if (indexPath.row == kDANewCaseFieldCause) {
                
            if (hasCaseSelected == NO) {
            
                NSArray *causesList;
            
                switch (assistanceType) {
                    case kDAAssistanceTypeAutomotive:
                        causesList = [[DAAssistance application] automotiveManager].causesList;
                        break;
                    case kDAAssistanceTypeAutomaker:
                        causesList = [[DAAssistance application] automakerManager].causesList;
                        break;
                    case kDAAssistanceTypeProperty:
                        causesList = [[DAAssistance application] propertyManager].causesList;
                        break;
                    default:
                        break;
                }

                DAListViewController *listView = [[DAListViewController alloc] initWithListItems:causesList
                                                                                       title:DALocalizedString(@"Cause", nil) 
                                                                                         tag:kDANewCaseFieldCause];
            
                listView.headerText = DALocalizedString(@"ChooseCause", nil);
                listView.preselectedItem = selectedCause;
            
                [listView setDelegate:self];
                [self.navigationController pushViewController:listView animated:YES];
            }
        }
        else if (indexPath.row == kDANewCaseFieldProblem && hasProblem) {

            NSArray *problemsList;
            
            switch (assistanceType) {
                case kDAAssistanceTypeAutomotive:
                    problemsList = [[DAAssistance application] automotiveManager].problemsList;
                    break;
                case kDAAssistanceTypeAutomaker:
                    problemsList = [[DAAssistance application] automakerManager].problemsList;
                    break;
                default:
                    break;
            }
            
            DAListViewController *listView = [[DAListViewController alloc] initWithListItems:problemsList 
                                                                                       title:DALocalizedString(@"Problem", nil)
                                                                                         tag:kDANewCaseFieldProblem];
            listView.headerText = DALocalizedString(@"ChooseVehicleProblem", nil);
            listView.preselectedItem = selectedProblem;
        
            [listView setDelegate:self];
            [self.navigationController pushViewController:listView animated:YES];
        }
        else if ((indexPath.row == kDANewCaseFieldService && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldService && !hasProblem)) {

            NSArray *servicesList;

            switch (assistanceType) {
                case kDAAssistanceTypeAutomotive:
                    servicesList = [[DAAssistance application] automotiveManager].servicesList;
                    break;
                case kDAAssistanceTypeAutomaker:
                    servicesList = [[DAAssistance application] automakerManager].servicesList;
                    break;
                case kDAAssistanceTypeProperty:
                    servicesList = [[DAAssistance application] propertyManager].servicesList;
                    break;
                default:
                    break;
            }
            
            DAListViewController *listView = [[DAListViewController alloc] initWithListItems:servicesList 
                                                                                       title:DALocalizedString(@"Service", nil) 
                                                                                         tag:kDANewCaseFieldService];
            listView.assistanceType = self.assistanceType;
            listView.headerText = DALocalizedString(@"ChooseService", nil);
            listView.preselectedItem = selectedService;
            listView.showCallToAssistanceOption = YES;
            
            [listView setDelegate:self];
            [self.navigationController pushViewController:listView animated:YES];
        }
        else if ((indexPath.row == kDANewCaseFieldLocation && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldLocation && !hasProblem)) {

            if (self.assistanceType != kDAAssistanceTypeProperty) {
            
                if (![Utility hasInternet]) {			
                    [Utility showNoInternetWarning];
                    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }
                
                DALocateMeOnMapViewController *locateOnMapViewController = [[DALocateMeOnMapViewController alloc]
                                                                            initWithAddress:selectedAddress];
                locateOnMapViewController.canEdit = (assistanceType == kDAAssistanceTypeAutomotive ||
                                                     assistanceType == kDAAssistanceTypeAutomaker);
                
                [locateOnMapViewController setDelegate:self];
                [self.navigationController pushViewController:locateOnMapViewController animated:YES];
            }
        }
        else if ((indexPath.row == kDANewCaseFieldAddressDetail && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldAddressDetail && !hasProblem)) {
            
            DAEditAddressDetailViewController *editAddressDetailView = [[DAEditAddressDetailViewController alloc] initWithNibName:@"DAEditAddressDetailViewController" bundle:[NSBundle bundleForClass:[self class]]];
            
            [editAddressDetailView setAddressDetailText:selectedAddressDetail];
            [editAddressDetailView setDelegate:self];
            [self.navigationController pushViewController:editAddressDetailView animated:YES];
        }
        else if ((indexPath.row == kDANewCaseFieldSchedule && hasProblem) ||
                 (indexPath.row+1 == kDANewCaseFieldSchedule && !hasProblem)) {
            
            DASchedulePickerViewController *schedulePickerVC = [[DASchedulePickerViewController alloc] 
                                                                initWithScheduleBeginDate:scheduleBeginDate 
                                                                                  endDate:scheduleEndDate];
            [schedulePickerVC setDelegate:self];
                    
            [self.navigationController pushViewController:schedulePickerVC animated:YES];
        }
    } else {
        [self btnSend_Click:nil];
    }
}

#pragma mark DAPolicyListViewController methods

- (void)policyListViewControllerDelegate:(DAPolicyListViewController *)policyListViewControllerDelegate didSelectPolicy:(DAPolicyBase *)selectedBasePolicy {	
	
    Client *client = [[Client alloc] init];
    
	switch (assistanceType) {
		case kDAAssistanceTypeAutomotive:
            
            if (client.clientID == 173) {
                policyKey = [(DAAutomotivePolicy *)selectedBasePolicy policyID];
            } else {
                policyKey = [(DAAutomotivePolicy *)selectedBasePolicy vehiclePlate];
            }
            
			break;
		case kDAAssistanceTypeAutomaker:
			policyKey = [(DAAutomotivePolicy *)selectedBasePolicy vehicleModel];
			break;
		case kDAAssistanceTypeProperty:
			policyKey = [(DAPropertyPolicy *)selectedBasePolicy policyID];
			selectedAddress = [(DAPropertyPolicy *)selectedBasePolicy address];			
			break;
		default:
			break;
	}

	selectedPolicy = selectedBasePolicy;
	
	[self.navigationController popToViewController:self animated:YES];
	[self.tableView reloadData];
}

#pragma mark DAListViewControllerDelegate methods

- (void)listViewController:(DAListViewController *)listViewController didSelectItem:(DAKeyValue *)item {

	switch (listViewController.tag) {
		case kDANewCaseFieldCause: {
			selectedCause = item;
			if (selectedCause.key == @"31")
				hasProblem = YES;
			else if (selectedCause.key == @"30") {
				hasProblem = NO;
				if (assistanceType == kDAAssistanceTypeAutomotive)
					selectedService = [[[DAAssistance application] automotiveManager].servicesList objectAtIndex:1];
				else if (assistanceType == kDAAssistanceTypeAutomaker) {
                    if([DAConfiguration settings].applicationClient.clientID == 30) { //AUDI SOMENTE REBOQUE
                        selectedService = [[[DAAssistance application] automakerManager].servicesList objectAtIndex:0];
                    }
                    else {
                        selectedService = [[[DAAssistance application] automakerManager].servicesList objectAtIndex:1];
                    }
                        
					
                }
			}
			break;
		}
		case kDANewCaseFieldProblem: {
			selectedProblem = item;
			if (selectedProblem.tag == @"R40") {
				if (assistanceType == kDAAssistanceTypeAutomotive)
					selectedService = [[[DAAssistance application] automotiveManager].servicesList objectAtIndex:0];
				else if (assistanceType == kDAAssistanceTypeAutomaker)
					selectedService = [[[DAAssistance application] automakerManager].servicesList objectAtIndex:0];
			}
			break;
		}
		case kDANewCaseFieldService:
			selectedService = item;
			break;
		default:
			break;
	}
	
	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}

#pragma mark DALocateMeOnMapViewControllerDelegate methods

- (void)locateMeOnMapViewController:(DALocateMeOnMapViewController *)locateMeOnMapViewController 
				   didSelectAddress:(DAAddress *)selectedAddressOnMap {
	
	selectedAddress = selectedAddressOnMap;

	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}

#pragma mark EditAddressDetailViewControllerDelegate methods

- (void)editAddressDetailViewController:(DAEditAddressDetailViewController *)editAddressDetailViewController 
				   didEditAddressDetail:(NSString *)addressDetail {
	
	selectedAddressDetail = addressDetail;

	[self.navigationController popViewControllerAnimated:YES];
	[self.tableView reloadData];
}

#pragma mark Toolbar methods

- (void)makeToolbar {
	//Caclulate the height of the toolbar
	CGFloat toolbarHeight = 46;
	
	//Get the bounds of the parent view
	CGRect rootViewBounds = self.view.bounds;
	
	//Get the height of the parent view.
	CGFloat rootViewHeight = self.tableView.frame.size.height;
	
	//Get the width of the parent view,
	CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
	
	//Create a rectangle for the toolbar
	CGRect rectArea = CGRectMake(6, rootViewHeight - toolbarHeight - 46, rootViewWidth - 12, toolbarHeight);

    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:@"21_assistencia-nova-btn-enviar.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
    
    UIButton *btnSend = [[UIButton alloc] initWithFrame:rectArea];
    [btnSend addTarget:self action:@selector(btnSend_Click:) forControlEvents:UIControlEventTouchUpInside];
    [btnSend setImage:image forState:UIControlStateNormal];
//    [btnSend setBackgroundImage:[UIImage imageNamed:@"21_assistencia-nova-btn-enviar.png"] forState:UIControlStateNormal];
    
	[self.view addSubview:btnSend];
}

-(void) btnSend_Click:(id)sender {
	
    NSLog(@"BTNSENDCLIDL FTW");
    
	if (![Utility hasInternet]) {			
		[Utility showNoInternetWarning];
		return;
	}
	
	if (selectedPolicy != nil && selectedCause != nil &&
		selectedService != nil && selectedAddress.streetName != nil) {
		
		[self showProgress];
		[self incrementBar];
		
		fileObj = [[DAFileBase alloc] init];
		fileObj.contractNumber = selectedPolicy.policyID;
		fileObj.phoneAreaCode = [[DAUserPhone getUserPhone] areaCode];
		fileObj.phoneNumber = [[DAUserPhone getUserPhone] phoneNumber];
		fileObj.fileCause = [selectedCause key];
		fileObj.problemCode = (selectedProblem == nil) ? @"-1" : [selectedProblem key];
		fileObj.serviceCode = [selectedService key];
		fileObj.fileCity = [selectedAddress.city uppercaseString];
		fileObj.fileState = [selectedAddress.state uppercaseString];
		fileObj.streetName = [selectedAddress.streetName uppercaseString];
		fileObj.houseNumber = [selectedAddress houseNumber];
		fileObj.district = [selectedAddress district];
		fileObj.latitude = [NSString stringWithFormat:@"%0.6f", selectedAddress.coordinate.latitude];
		fileObj.longitude = [NSString stringWithFormat:@"%0.6f", selectedAddress.coordinate.longitude];
		fileObj.addressDetail = [selectedAddressDetail uppercaseString];
		fileObj.zipcode = selectedAddress.zipcode;
						   
		DACoverageControlChecker *coverageChecker = [[DACoverageControlChecker alloc] init];
		[coverageChecker setDelegate:self];
		[coverageChecker checkCoverages:fileObj];
	} else {
		UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
										   initWithTitle:DALocalizedString(@"CantCreateCase", nil)
										   message:DALocalizedString(@"InformationMissing", nil) 
										   delegate:nil cancelButtonTitle:nil
										   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
		[locationErrorAlert show];
	}
}

- (void)createServiceRequest:(DAFileBase *)createdCase {
	
	[self incrementBar];
	_progressMessageLabel.text = DALocalizedString(@"SearchingNearestProvider", nil);
	//[baseSheet setMessage:DALocalizedString(@"SearchingNearestProvider", nil)];
	
	createdCase.scheduleBeginDate = scheduleBeginDate;
	createdCase.scheduleEndDate = scheduleEndDate;
	
	DAAutomotiveServiceRequestCreator *serviceRequestCreator = [[DAAutomotiveServiceRequestCreator alloc] init];
	[serviceRequestCreator setDelegate:self];
	[serviceRequestCreator createServiceRequest:createdCase];
}

#pragma mark File delegate methods

- (void)coverageControlDidGetOK:(DAFileBase *)file {
	[self incrementBar];
	//[baseSheet setMessage:DALocalizedString(@"CreatingCase", nil)];
	_progressMessageLabel.text = DALocalizedString(@"CreatingCase", nil);
	
	DACaseCreationWS *caseCreator = [[DACaseCreationWS alloc] init];
	[caseCreator setDelegate:self];
	[caseCreator createCase:file forAssistanceType:assistanceType];
}

- (void)coverageControlDidGetRefusal:(NSString *)message {
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"CantCreateCase", nil) 
														 message:DALocalizedString(@"CoverageExceededWarning", nil) 
														delegate:self cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];	
}

- (void)coverageControlDidFailWithError:(NSError *)error {
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"CantCreateCase", nil) 
														 message:DALocalizedString(@"PleaseTryAgain", nil)
														delegate:nil cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
}

- (void)coverageControlDidFailWithNoInternet {
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:DALocalizedString(@"CantCreateCase", nil)
									   message:DALocalizedString(@"NoInternetWarning", nil)
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[locationErrorAlert show];
}

#pragma mark File delegate methods

- (void)automotiveFileCreator:(DAAutomotiveFileCreator *)fileCreator didCreateFile:(NSString *)fileNumber
					  request:(NSString *)requestNumber newFile:(DAAutomotiveFile *)newFileObj {
	
	if (![fileNumber isEqualToString:@"-1"]) {
		
		[self incrementBar];
//		[baseSheet setMessage:DALocalizedString(@"SearchingNearestProvider", nil)];
		_progressMessageLabel.text = DALocalizedString(@"SearchingNearestProvider", nil);
		
		DAAutomotiveServiceRequestCreator *serviceRequestCreator = [[DAAutomotiveServiceRequestCreator alloc] init];
		[serviceRequestCreator setDelegate:self];
		[serviceRequestCreator createServiceRequest:newFileObj];
	}
}

- (void)automotiveFileCreator:(DAAutomotiveFileCreator *)fileCreator didFailWithError:(NSError *)error {
	
	//NSLog(@"error: %@", [error localizedDescription]);
	
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"CantCreateCase", nil) 
														 message:DALocalizedString(@"PleaseTryAgain", nil) 
														delegate:self cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
}

- (void)automotiveFileCreatorDidFailWithNoInternetConnection:(DAAutomotiveFileCreator *)fileCreator {
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:DALocalizedString(@"CantCreateCase", nil)
									   message:DALocalizedString(@"NoInternetWarning", nil)
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[locationErrorAlert show];
}

#pragma mark DACaseCreationWS methods

- (void)caseCreationWS:(DACaseCreationWS *)caseCreationWS didCreateCase:(DAFileBase *)createdCase {
	
	if (![createdCase.fileNumber isEqualToString:@"-1"]) {
		
		if (assistanceType == kDAAssistanceTypeProperty) {
			
			//[baseSheet setMessage:DALocalizedString(@"GettingLocationCoordinates", nil)];
			_progressMessageLabel.text = DALocalizedString(@"GettingLocationCoordinates", nil);
			
			DAGeocoder *geocoder = [[DAGeocoder alloc] init];
			[geocoder setDelegate:self];
			
			DAAddress *address = [[DAAddress alloc] init];
			address.streetName = fileObj.streetName;
			address.houseNumber = fileObj.houseNumber;
			address.city = fileObj.fileCity;
			address.state = fileObj.fileState;
			
			[geocoder searchWithAddress:address];
		}
		else {
			
			[self createServiceRequest:createdCase];
		}
	}
}

- (void)caseCreationWS:(DACaseCreationWS *)caseCreationWS didFailWithErrorMessage:(NSString *)errorMessage {
	
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:DALocalizedString(@"CantCreateCase", nil)
									   message:errorMessage 
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[locationErrorAlert show];
}

#pragma mark DAGeocoderDelegate methods

- (void)geocoder:(DAGeocoder *)geocoder didFindAddresses:(NSArray *)addresses {
	
	if ([addresses count] > 0) {
		
		DAAddress *address = [addresses objectAtIndex:0];
		fileObj.latitude = [NSString stringWithFormat:@"%.6f", address.coordinate.latitude];
		fileObj.longitude = [NSString stringWithFormat:@"%.6f", address.coordinate.longitude];
		
	}

	[self createServiceRequest:fileObj];
}

- (void)geocoder:(DAGeocoder *)geocoder didFailWithError:(NSError *)error {
	[self createServiceRequest:fileObj];
}

- (void)geocoderDidFailNoInternetConnection:(DAGeocoder *)geocoder {

	[self createServiceRequest:fileObj];	
}

#pragma mark ServiceRequest delegate methods

- (void)automotiveServiceRequestCreator:(DAAutomotiveServiceRequestCreator *)serviceRequestCreator
				didCreateServiceRequest:(NSString *)fileNumber request:(NSString *)requestNumber newFile:(DAAutomotiveFile *)newFileObj {
	
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES]; 
	[self dismissProgressBarPanel];
	//[[AppConfig sharedConfiguration].automotiveService addFile:newFileObj];
	
	DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] init];
	actionResult.actionType = kDAActionCreateCase;	
	actionResult.actionParameters = [NSString stringWithFormat:@"%d", newFileObj.fileNumber];
	actionResult.resultType = kDAResultSuccess;
	
	[DAAccessLog saveAccessLog:actionResult];
	
	UIAlertView *fileCreatedAlert = [[UIAlertView alloc] 
									 initWithTitle:[NSString stringWithFormat:DALocalizedString(@"CaseCreatedSuccessfully", nil), fileNumber] 
									 message:DALocalizedString(@"CaseCreatedMonitoringWarning", nil)  
									 delegate:self cancelButtonTitle:nil
									 otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[fileCreatedAlert show];
    
    [GoogleAnalyticsManager send:@"Assistência Automotiva: Concluída"];
    NSLog(@"Assistência Automotiva: Concluída");
    
    
    [[DASharedManager sharedManager] addCase:fileNumber];
    
    [self scheduleQualitySurveyWithFileNumber:[fileNumber intValue]];
}


- (void)automotiveServiceRequestCreator:(DAAutomotiveServiceRequestCreator *)serviceRequestCreator 
					   didFailWithError:(NSError *)error {
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:DALocalizedString(@"FailCreatingCase", nil)
									   message:DALocalizedString(@"CaseCrationFailureWarning", nil) 
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[locationErrorAlert show];
}

- (void)automotiveServiceRequestCreatorDidFailWithNoInternet:(DAAutomotiveServiceRequestCreator *)serviceRequestCreator {
	//[baseSheet dismissWithClickedButtonIndex:0 animated:YES];
	[self dismissProgressBarPanel];
	UIAlertView *locationErrorAlert = [[UIAlertView alloc] 
									   initWithTitle:DALocalizedString(@"FailCreatingCase", nil) 
									   message:DALocalizedString(@"CaseCrationFailureWarning", nil)  
									   delegate:self cancelButtonTitle:nil
									   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[locationErrorAlert show];
}

#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark Proggress base methods

- (void)showProgress {
	
	if (nil == _progressPanelView) {
        CGPoint center;
		_progressOverlayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, self.parentViewController.view.frame.size.height)];
		_progressOverlayView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
		[self.parentViewController.view addSubview:_progressOverlayView];
		
		
        _progressPanelView = [[UIView alloc] initWithFrame:CGRectMake(0, self.parentViewController.view.frame.size.height, self.parentViewController.view.frame.size.width, 136)];
        center = _progressPanelView.center;
        center.x = self.parentViewController.view.frame.size.width/2;
        _progressPanelView.center = center;
		[self.parentViewController.view addSubview:_progressPanelView];
		
        NSBundle *bundle = [NSBundle bundleForClass:[self class]];
        UIImage *image = [UIImage imageNamed:@"CreateCaseProgressPanelBG.png" inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
        
		UIImageView *progressPanelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.parentViewController.view.frame.size.width, 136)];
		progressPanelImageView.image = image;
		[_progressPanelView addSubview:progressPanelImageView];
										
		
		_progressTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 15, self.parentViewController.view.frame.size.width, 20)];
		_progressTitleLabel.font = [UIFont systemFontOfSize:14];
		_progressTitleLabel.textAlignment = UITextAlignmentCenter;
		_progressTitleLabel.backgroundColor = [UIColor clearColor];
		_progressTitleLabel.textColor = [UIColor whiteColor];
		_progressTitleLabel.shadowColor = [UIColor blackColor];
		_progressTitleLabel.shadowOffset = CGSizeMake(0, 1);
		_progressTitleLabel.text = DALocalizedString(@"PleaseWait", nil);
        center = _progressTitleLabel.center;
        center.x = _progressPanelView.frame.size.width/2;
        _progressTitleLabel.center = center;
		[_progressPanelView addSubview:_progressTitleLabel];
		
		
		_progressMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 45, self.parentViewController.view.frame.size.width, 20)];
		_progressMessageLabel.font = [UIFont systemFontOfSize:16];
		_progressMessageLabel.textAlignment = UITextAlignmentCenter;
		_progressMessageLabel.backgroundColor = [UIColor clearColor];
		_progressMessageLabel.textColor = [UIColor whiteColor];
		_progressMessageLabel.shadowColor = [UIColor blackColor];
        _progressMessageLabel.shadowOffset = CGSizeMake(0, 1);
        center = _progressMessageLabel.center;
        center.x = _progressPanelView.frame.size.width/2;
        _progressMessageLabel.center = center;
		[_progressPanelView addSubview:_progressMessageLabel];
		
		_progressBarView = [[UIProgressView alloc] initWithFrame:CGRectMake(self.parentViewController.view.frame.size.width/2, 85.0f, 220.0f, 90.0f)];
        [_progressBarView setProgressViewStyle:UIProgressViewStyleDefault];
        center = _progressBarView.center;
        center.x = _progressPanelView.frame.size.width/2;
        _progressBarView.center = center;
		[_progressPanelView addSubview:_progressBarView];
	}
	
	[_progressBarView setProgress:(amountDone = 0.0f)];
	
	[UIView beginAnimations:@"ShowProgressView" context:NULL];
	[UIView setAnimationDuration:0.4];
	
	CGRect progressPanelFrame = _progressPanelView.frame;
	progressPanelFrame.origin.y = self.parentViewController.view.frame.size.height - 136;
	[_progressPanelView setFrame:progressPanelFrame];
	
	[UIView commitAnimations];
	
}

- (void) incrementBar {
    amountDone += 0.26f;
	
	//UIProgressView *progbar = (UIProgressView *)[baseSheet viewWithTag:PROGRESS_BAR];
    //[progbar setProgress:amountDone];
    
	[_progressBarView setProgress:amountDone];
	if (amountDone >= 1.0) 
	{
		[self dismissProgressBarPanel];
		//[baseSheet dismissWithClickedButtonIndex:0 animated:YES]; 
	}
}

- (void)dismissProgressBarPanel {

	[UIView beginAnimations:@"DismissProgressView" context:NULL];
	[UIView setAnimationDuration:0.4];
	
	CGRect progressPanelFrame = _progressPanelView.frame;
	progressPanelFrame.origin.y = self.parentViewController.view.frame.size.height;
	[_progressPanelView setFrame:progressPanelFrame];
	
	[UIView commitAnimations];
	
	[_progressPanelView removeFromSuperview];
	[_progressOverlayView removeFromSuperview];
	
	_progressPanelView = nil;
	_progressOverlayView = nil;
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
}

- (IBAction)btnCancel:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark DASchedulePickerViewControllerDelegate methods

- (void)schedulePickerViewControllerDidPickScheduleDates:(DASchedulePickerViewController *)schedulePickerViewController {

	scheduleBeginDate = schedulePickerViewController.scheduleStartDate;
	scheduleEndDate = schedulePickerViewController.scheduleEndDate;
	
	[self.tableView reloadData];
}


#pragma mark -
#pragma mark QualitySurvey

- (void)scheduleQualitySurveyWithFileNumber:(NSInteger)fileNumber {
	if ([DAConfiguration settings].applicationClient.qualitySurveyEnabled )
	{
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		
        localNotification.userInfo = [NSDictionary dictionaryWithObject:[NSNumber numberWithInt:fileNumber] forKey:@"DAFileNumber"];
        
		// Hoje + 4 horas e tem que ter no perido das 08:00 as 22:00
		NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
		[calendar setTimeZone:[NSTimeZone systemTimeZone]];
		NSDate *now = [NSDate date] ;
		
		NSDateComponents *nowComps = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit fromDate:now];
		
		NSInteger hour = [nowComps hour];
		if ( hour <= 5  ) {
			[nowComps setHour:12];		
		}
		else if ( hour > 16 ) {
			[nowComps setHour:12];		
			[nowComps setDay:[nowComps day] + 1];
		}
		else {
			[nowComps setHour:[nowComps hour] + 4];
		}
		
		//NSDate *pushDate =[calendar dateFromComponents:nowComps]; 
		NSDate *pushDate =[NSDate dateWithTimeIntervalSinceNow:300]; 
		NSLog(@"%@", [pushDate description]);
		
		
		[localNotification setFireDate:pushDate];
		NSString *question =  [NSString stringWithFormat: @"Você deseja responder a pesquisa de qualidade referente ao atendimento %d", fileNumber];
		[localNotification setAlertBody:question];
		[localNotification setAlertAction:@"Sim"];
		
		[[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
	}
}
								

@end

