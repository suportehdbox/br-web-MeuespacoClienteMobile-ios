//
//  SinistroNovoEnvolvidosPolicialViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PoliceOfficer.h"
#import "Address.h"
#import "LibertyMobileViewController.h"

@interface SinistroNovoEnvolvidosPolicialViewController : LibertyMobileViewController <UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate>
{
    NSMutableArray  *arrayFields;
    
    NSManagedObjectContext *managedObjectContext;
    PoliceOfficer *policeOfficer;
    BOOL newRecord;
	BOOL editable;

	UIAlertView     *uiAlertView;
	UIActionSheet   *uiActionSheet;
    
    int SECTION_TOTAL;
}

//Property

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) PoliceOfficer *policeOfficer;
@property BOOL newRecord;
@property BOOL editable;

@property (nonatomic, retain) UIAlertView *uiAlertView;
@property (nonatomic, retain) UIActionSheet *uiActionSheet;

-(id)initWithPoliceOfficer:(PoliceOfficer *)policeOfficerInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andIsNew:(BOOL)isNew andCanEdit:(BOOL)canEdit;

//Actions
//- (IBAction)btnCancel:(id)sender;
- (IBAction)btnConcluido:(id)sender;
- (BOOL) validateFields;
- (IBAction)btnDelete:(id)sender;

//Visible or Hide Toolbar Keyboard Navigation
-(void) saveState;
-(void) rollbackState;


@end
