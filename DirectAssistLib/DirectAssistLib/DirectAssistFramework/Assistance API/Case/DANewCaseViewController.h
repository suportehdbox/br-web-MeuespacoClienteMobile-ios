//
//  NewCaseViewController.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 7/28/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DALocateMeOnMapViewController.h"
#import "DAEditAddressDetailViewController.h"
#import "DAPolicyBase.h"
#import "DAAddress.h"
#import "DAListViewController.h"
#import "DACoverageControlChecker.h"
#import "DAAutomotiveFileCreator.h"
#import "DAAutomotiveServiceRequestCreator.h"
#import "DAAutomakerCreateCaseWS.h"
#import "DASchedulePickerViewController.h"
#import "DAPolicyListViewController.h"
#import "DACaseCreationWS.h"
#import "DAGeocoder.h"

@class DALocationCell, DAAddressDetailCell;

@interface DANewCaseViewController : UITableViewController <DALocateMeOnMapViewControllerDelegate,
	DAListViewControllerDelegate, UIActionSheetDelegate,
	DACoverageControlCheckerDelegate, DAAutomotiveFileCreatorDelegate, DAAutomotiveServiceRequestCreatorDelegate,
	EditAddressDetailViewControllerDelegate, DAAutomakerCreateCaseWSDelegate,
	DASchedulePickerViewControllerDelegate, DAPolicyListViewControllerDelegate, DACaseCreationWSDelegate,
	DAGeocoderDelegate, UIAlertViewDelegate> {

	IBOutlet DALocationCell *locationCell;
	IBOutlet DAAddressDetailCell *addressDetailCell;
	
	DAAssistanceType assistanceType;
	
    BOOL hasCaseSelected;
	BOOL hasProblem;
	BOOL hasSchedule;
	NSString *policyKey;
	
	DAPolicyBase *selectedPolicy;
	DAAddress *selectedAddress;
	DAKeyValue *selectedCause;
	DAKeyValue *selectedProblem;
	DAKeyValue *selectedService;
	NSString *selectedAddressDetail;
	
	NSDate *scheduleBeginDate;
	NSDate *scheduleEndDate;
		
	float			amountDone;
//	UIActionSheet	*baseSheet;
	
	// Progress panel
	UIView *_progressOverlayView;
	UIView *_progressPanelView;
	UILabel *_progressTitleLabel;
	UILabel *_progressMessageLabel;
	UIProgressView *_progressBarView;		
		
	DAFileBase *fileObj;
		
		
}

@property (nonatomic) DAAssistanceType assistanceType;

- (void)makeToolbar;
- (void)incrementBar;
- (void)showProgress;
- (void)createServiceRequest:(DAFileBase *)createdCase;
- (void)setPolicyKey:(NSString *)thePolicyKey;

- (IBAction)btnCancel:(id)sender;

@end
