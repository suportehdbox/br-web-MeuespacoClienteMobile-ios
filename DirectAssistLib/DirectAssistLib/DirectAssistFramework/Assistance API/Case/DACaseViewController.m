
//
//  DACaseViewController.m
//  DirectAssist
//
//  Created by Ricardo Ramos on 18/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import "DACaseViewController.h"
#import "DAServiceMonitoringViewController.h"
#import "DAServiceDispatchFinder.h"
#import "DAServiceDispatch.h"
#import "DAAutomotiveFile.h"
#import "DAStatusViewController.h"
#import "DAWebServiceActionResult.h"
#import "DAAccessLog.h"

@implementation DACaseViewController

@synthesize selectedFile, selectedDispatch;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.title = DALocalizedString(@"File", nil);
	
	lblFileNumberLabel.text = [DALocalizedString(@"CaseNumber", nil) stringByAppendingString:@":"];
	lblDispatchStatusLabel.text = [DALocalizedString(@"Status", nil) stringByAppendingString:@":"];
	lblArrivalTimeLabel.text = [DALocalizedString(@"ArrivalTime", nil) stringByAppendingString:@":"];
	lblVehiclePlateLabel.text = [DALocalizedString(@"ProviderLicence", nil) stringByAppendingString:@":"];
	btnViewOnMap.titleLabel.text = DALocalizedString(@"ShowOnMap", nil);
	
	
	lblArrivalTime.hidden = YES;
	lblArrivalTimeLabel.hidden = YES;
	lblVehiclePlate.hidden = YES;
	lblVehiclePlateLabel.hidden = YES;
	btnQualitySurvey.hidden = YES;
	
	dispatchFinder = [[DAServiceDispatchFinder alloc] init];
	dispatchFinder.delegate = self;
	
	statusView = [[DAStatusViewController alloc] initWithStatus:DALocalizedString(@"LoadingFile", nil)];
    
    [Utility addBackButtonNavigationBar:self action:@selector(btnBack:)];
	
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self loadFile];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    //Caclulate the height of the toolbar
    CGFloat toolbarHeight = 44;
    
    //Get the bounds of the parent view
    CGRect rootViewBounds = self.view.bounds;
    
    //Get the height of the parent view.
    CGFloat rootViewHeight = CGRectGetHeight(rootViewBounds);
    
    //Get the width of the parent view,
    CGFloat rootViewWidth = CGRectGetWidth(rootViewBounds);
    
    //Create a rectangle for the toolbar
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight + 4, rootViewWidth, toolbarHeight);
    
    toolBar = [[UIToolbar alloc] initWithFrame:rectArea];
    
    UIBarButtonItem *btnSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *btnSend = [[UIBarButtonItem alloc] initWithTitle:DALocalizedString(@"Refresh", nil)
                                                                style:UIBarButtonItemStyleBordered target:self action:@selector(btnSend_Clicked:)];
    
    toolBar.tintColor = [AppConfig sharedConfiguration].appClient.defaultColor;
    [toolBar setItems:[NSArray arrayWithObjects:btnSend, btnSpace, nil]];
    
    [self.view addSubview:toolBar];

    
    btnViewOnMap.tintColor = [AppConfig sharedConfiguration].appClient.defaultColor;
}

- (void)loadFile {

	[statusView showInViewController:self];
	[dispatchFinder getServiceDispatchWithFileNumber:[selectedFile.fileNumber intValue]];
}

- (IBAction)btnBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)btnSend_Clicked:(id)sender {
	[self loadFile];
}

-(IBAction) btnViewOnMap_Clicked:(id)sender {
	
	DAServiceMonitoringViewController *mapVC = [[DAServiceMonitoringViewController alloc] init];
	mapVC.fileNumber = [selectedFile.fileNumber intValue];
	[self.navigationController pushViewController:mapVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning]; // Releases the view if it doesn't have a superview
    // Release anything that's not essential, such as cached data
}





- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFindServiceDispatch:(DAServiceDispatch *)aDispatch {
	
	DAServiceDispatch *dispatch = aDispatch;
	
	selectedDispatch = [[DAServiceDispatch alloc] init];
	selectedDispatch.providerLatitude = dispatch.providerLatitude;
	selectedDispatch.providerLongitude = dispatch.providerLongitude;
	
	lblFIleNumber.text = [NSString stringWithFormat:@"%d", dispatch.fileNumber];
	lblArrivalTime.text = [NSString stringWithFormat:@"%@ %@", dispatch.arrivalTime, [DALocalizedString(@"Minutes", nil) lowercaseString]];
	
	NSString *statusText;
	
	lblArrivalTime.hidden = NO;
	lblArrivalTimeLabel.hidden = NO;
	lblVehiclePlate.hidden = NO;
	lblVehiclePlateLabel.hidden = NO;
	btnQualitySurvey.hidden = YES;
	
	
	if ([dispatch.dispatchStatus isEqualToString:@"1"] || 
		[dispatch.dispatchStatus isEqualToString:@"2"] || 
		[dispatch.dispatchStatus isEqualToString:@"3"]) {
		statusText = DALocalizedString(@"WaitingDispatch", nil);
		lblArrivalTime.hidden = YES;
		lblArrivalTimeLabel.hidden = YES;
		lblVehiclePlate.hidden = YES;
		lblVehiclePlateLabel.hidden = YES;
	}
	else if ([dispatch.dispatchStatus isEqualToString:@"4"]) {
			statusText = DALocalizedString(@"SentToProvider", nil);
			lblArrivalTime.hidden = YES;
			lblArrivalTimeLabel.hidden = YES;
			lblVehiclePlate.hidden = YES;
			lblVehiclePlateLabel.hidden = YES;
	}
	else if ([dispatch.dispatchStatus isEqualToString:@"5"]) {
		
		if (!dispatch.isSchedule) {
		
			statusText = DALocalizedString(@"ServiceOnWay", nil);
			
			NSTimeInterval tmc = [self.selectedFile.creationDate timeIntervalSinceNow];
			//NSLog(@"%.0f", [dispatch.arrivalTime intValue] + (tmc / 60));
			lblArrivalTime.text = [NSString stringWithFormat:@"%.0f %@", [dispatch.arrivalTime intValue] + (tmc / 60), DALocalizedString(@"Minutes", nil)];	
			
			if ([dispatch.dispatchChannel isEqualToString:@"3"]) {
				lblVehiclePlate.hidden = NO;
				lblVehiclePlateLabel.hidden = NO;
			}
			else {
				lblVehiclePlate.hidden = YES;
				lblVehiclePlateLabel.hidden = YES;
			} 
		}
		else {
			
			statusText = DALocalizedString(@"ServiceScheduled", nil);
			
			NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
			[dateFormatter setDateFormat:@"dd/MMM"];
			
			NSDateFormatter *timeFormater = [[NSDateFormatter alloc] init];
			[timeFormater setDateFormat:@"HH:mm"];
			
			NSMutableString *scheduleText = [NSMutableString stringWithString:[dateFormatter stringFromDate:dispatch.scheduleBeginDate]];
			
			if (nil != dispatch.scheduleEndDate) 
				[scheduleText appendFormat:@" %@ %@ %@ %@", [DALocalizedString(@"Between", nil) lowercaseString], [timeFormater stringFromDate:dispatch.scheduleBeginDate], [DALocalizedString(@"And", nil) lowercaseString], [timeFormater stringFromDate:dispatch.scheduleEndDate]];
			else 
				[scheduleText appendFormat:@" %@", [timeFormater stringFromDate:dispatch.scheduleBeginDate]];
			
			
			lblArrivalTime.text = scheduleText;	
			
			lblVehiclePlate.hidden = YES;
			lblVehiclePlateLabel.hidden = YES;

		}

		
	}
	else if ([dispatch.dispatchStatus isEqualToString:@"6"]) {
		statusText = DALocalizedString(@"InService", nil);
		
		lblArrivalTime.hidden = YES;
		lblArrivalTimeLabel.hidden = YES;
	
		if ([dispatch.dispatchChannel isEqualToString:@"3"]) {
			lblVehiclePlate.hidden = NO;
			lblVehiclePlateLabel.hidden = NO;
		}
		else {
			lblVehiclePlate.hidden = YES;
			lblVehiclePlateLabel.hidden = YES;
		} 		
	}	
	else {
		statusText = DALocalizedString(@"ServiceFinished", nil);
		lblArrivalTime.hidden = YES;
		lblArrivalTimeLabel.hidden = YES;
		lblVehiclePlate.hidden = YES;
		lblVehiclePlateLabel.hidden = YES;
	}
	
	lblDispatchStatus.text = statusText;
	lblVehiclePlate.text = dispatch.vehiclePlate;
	
	if ([dispatch.dispatchChannel isEqualToString:@"3"] && 
		([dispatch.dispatchStatus isEqualToString:@"5"] || [dispatch.dispatchStatus isEqualToString:@"6"])) 
		btnViewOnMap.hidden = NO;
	else 
		btnViewOnMap.hidden = YES;

	[statusView dismiss];
	
	DAWebServiceActionResult *actionResult = [[DAWebServiceActionResult alloc] init];
	actionResult.actionType = kDAActionGetServiceDispatch;
	actionResult.actionParameters = [NSString stringWithFormat:@"%d", dispatch.fileNumber];
	actionResult.resultType = kDAResultSuccess;
	
	[DAAccessLog saveAccessLog:actionResult];
}

- (void)serviceDispatchFinder:(DAServiceDispatchFinder *)dispatchFinder didFailWithError:(NSError *)error {
	[statusView dismiss];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"FailLoadingFile", nil) 
														message:DALocalizedString(@"UnknowError", nil)
													   delegate:self 
											   cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
}

- (void)serviceDispatchFinderDidFailWithNoInternetConnection:(DAServiceDispatchFinder *)dispatchFinder {
	[statusView dismiss];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"FailLoadingFile", nil)
														 message:DALocalizedString(@"NoInternetWarning", nil)
														delegate:self cancelButtonTitle:nil
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
	
}

- (void)serviceDispatchFinderDidFailWithNoResults:(DAServiceDispatchFinder *)dispatchFinder {
	[statusView dismiss];
	UIAlertView *errorAlert = [[UIAlertView alloc] initWithTitle:DALocalizedString(@"FailLoadingFile", nil)  
														 message:DALocalizedString(@"FileNotFound", nil)
														delegate:self 
											   cancelButtonTitle:nil 
											   otherButtonTitles:DALocalizedString(@"OK", nil), nil];
	[errorAlert show];
}

#pragma mark UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
	[self.navigationController popViewControllerAnimated:YES];
}

#pragma mark --

@end
