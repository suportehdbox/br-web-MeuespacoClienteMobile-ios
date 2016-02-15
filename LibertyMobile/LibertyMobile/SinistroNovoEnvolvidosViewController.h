//
//  SinistroNovoEnvolvidosViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"
#import "Driver.h"
#import "PoliceOfficer.h"
#import "Witness.h"

@interface SinistroNovoEnvolvidosViewController : UIViewController
{
    UITableView *listaTableView;

    NSManagedObjectContext *managedObjectContext;
    Event *event;
    NSArray *otherDrivers;
    NSArray *witnesses;
    NSArray *policeOfficers;

	UIAlertView *uiAlertView;
}

@property (nonatomic, retain) IBOutlet UITableView *listaTableView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) NSArray *otherDrivers;
@property (nonatomic, retain) NSArray *witnesses;
@property (nonatomic, retain) NSArray *policeOfficers;
@property (nonatomic, retain) UIAlertView *uiAlertView;
@property BOOL editable;

- (id) initWithNovoEventContact:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;
- (void) addOtherDriver;
- (void) addWitness;
- (void) addPoliceOfficer;
- (IBAction) btnSinistroNovo:(id)sender;

@end
