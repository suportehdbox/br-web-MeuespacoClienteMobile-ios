//
//  DACaseViewController.h
//  DirectAssist
//
//  Created by Ricardo Ramos on 18/03/09.
//  Copyright 2009 Modial Assistance Brasil. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAServiceDispatchFinder.h"

@class DAServiceDispatchFinder, DAAutomotiveFile, DAServiceDispatch, DAStatusViewController;

@interface DACaseViewController : UIViewController <DAServiceDispatchFinderDelegate, UIAlertViewDelegate> {
	IBOutlet UIButton *btnViewOnMap;
	IBOutlet UIButton *btnQualitySurvey;	

	IBOutlet UILabel *lblDispatchStatus;
	IBOutlet UILabel *lblDispatchStatusLabel;
	IBOutlet UILabel *lblFIleNumber;
	IBOutlet UILabel *lblFileNumberLabel;
	IBOutlet UILabel *lblArrivalTime;
	IBOutlet UILabel *lblArrivalTimeLabel;
	IBOutlet UILabel *lblVehiclePlate;
	IBOutlet UILabel *lblVehiclePlateLabel;
	
	UIToolbar *toolBar;
	
	DAServiceDispatchFinder *dispatchFinder;
	
	DAServiceDispatch *selectedDispatch;
	DAAutomotiveFile *selectedFile;
	
	DAStatusViewController *statusView;
}

@property (nonatomic, strong) DAAutomotiveFile *selectedFile;
@property (nonatomic, strong) DAServiceDispatch *selectedDispatch;

-(IBAction) btnViewOnMap_Clicked:(id)sender;

- (void)loadFile;
- (IBAction)btnBack:(id)sender;
- (void)btnSend_Clicked:(id)sender;

@end
