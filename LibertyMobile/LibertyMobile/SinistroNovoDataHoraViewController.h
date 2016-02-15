//
//  SinistroNovoDataHoraViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/5/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"


@interface SinistroNovoDataHoraViewController : UIViewController
{
    UITextField* txtDateTime;
    UIDatePicker* datePickerDateTime;

    NSDate *selectedDate;
    NSDateFormatter *dateFormatter;
    NSDate *minDate;
    NSDate *maxDate;
}

@property (nonatomic, retain) IBOutlet UITextField* txtDateTime;
@property (nonatomic, retain) IBOutlet UIDatePicker* datePickerDateTime;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property BOOL editable;

@property (nonatomic, retain) NSDate *selectedDate;
@property (nonatomic, retain) NSDateFormatter *dateFormatter;
@property (nonatomic, retain) NSDate *minDate;
@property (nonatomic, retain) NSDate *maxDate;

-(id)initWithEventTime:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;
-(void) rollbackState;
-(void) saveState;
- (void)setupDatePicker;
//- (IBAction)btnCancel:(id)sender;
- (IBAction)btnConcluido:(id)sender;
- (IBAction)dateChanged:(id)sender;

@end
