//
//  SinistroNovoCompartilharViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/11/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "User.h"
#import "LibertyMobileViewController.h"

@interface SinistroNovoCompartilharViewController : LibertyMobileViewController <UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
{
    NSMutableArray  *arrayFields;
    
    NSManagedObjectContext *managedObjectContext;
    User *eventUser;
    BOOL editable;
}

//Property
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) User *eventUser;
@property BOOL editable;
@property (nonatomic, retain) UIAlertView *uiAlertView;

-(id)initWithEventShare:(User *)eventUserInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

//Actions
//- (IBAction)btnCancel:(id)sender;
- (IBAction)btnCompartilhar:(id)sender;

- (void) saveState;
- (void) rollbackState;

- (void) displayComposerSheet;
- (void) composeEmail;

@end
