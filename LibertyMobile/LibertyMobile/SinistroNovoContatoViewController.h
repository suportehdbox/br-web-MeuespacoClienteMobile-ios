//
//  SinistroNovoContatoViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "User.h"
#import "Address.h"
#import "LibertyMobileViewController.h"

@interface SinistroNovoContatoViewController : LibertyMobileViewController <UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray  *arrayFields;
    UIAlertView     *uiAlertView;
}

//Property
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) User *eventUser;
@property BOOL editable;
@property (nonatomic, retain) UIAlertView *uiAlertView;

-(id)initWithEvent:(User *)eventUserInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

//Functions View
//- (IBAction) btnCancel:(id)sender;
- (BOOL) validateFields;
- (IBAction) btnConcluido:(id)sender;

-(void) saveState;
-(void) rollbackState;

@end
