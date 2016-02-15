//
//  DACasesListViewController.h
//  DirectAssistFord
//
//  Created by Ricardo Ramos on 8/3/09.
//  Copyright 2009 Mondial Assistance. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DAProgressHUD.h"
#import "DACaseCell.h"
#import "DACasesListWS.h"

@interface DACasesListViewController : UITableViewController <DACasesListWSDelegate> {

	IBOutlet DACaseCell *fileCell;
	
	NSArray *casesList;
	
	DAAssistanceType assistanceType;
	DAProgressHUD *loadingHUD;
}

@property (nonatomic) DAAssistanceType assistanceType;

- (IBAction)btnBack:(id)sender;

@end
