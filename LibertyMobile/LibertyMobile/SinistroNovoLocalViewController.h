//
//  SinistroNovoLocalViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinistroNovoLocalMapaViewController.h"
#import "Address.h"
#import "LibertyMobileViewController.h"

@interface SinistroNovoLocalViewController : LibertyMobileViewController <SinistroNovoLocalMapaViewControllerDelegate, UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray  *camposItens;
}

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Address *eventLocation;
@property BOOL editable;

- (id)initWithEventLocal:(Address *)eventLocationInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

- (void) saveState;
- (void) rollbackState;

//- (IBAction)btnCancel:(id)sender;
- (IBAction)btnConcluido:(id)sender;

@end
