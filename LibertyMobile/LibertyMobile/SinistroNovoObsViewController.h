//
//  SinistroNovoObsViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/10/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "LibertyMobileViewController.h"

@interface SinistroNovoObsViewController : LibertyMobileViewController <UITableViewDelegate, UITextViewDelegate>
{
    NSMutableArray  *arrayFields;
    
	NSManagedObjectContext *managedObjectContext;
	Event *event;
    BOOL editable;
}

//Property
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property BOOL editable;

-(id)initWithEventObs:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

//Actions
//- (IBAction)btnCancel:(id)sender;
- (IBAction)btnConcluido:(id)sender;

- (void) saveState;
- (void) rollbackState;

@end
