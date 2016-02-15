//
//  SinistroNovoTipoSinistroViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface SinistroNovoTipoSinistroViewController : UIViewController
{
    UITableView* tipoSinistroTableView;
    NSMutableArray * tipoSinistros;
    NSString* selTipoSinistro;
}

@property (nonatomic, retain) IBOutlet UITableView* tipoSinistroTableView;
@property (nonatomic, retain) NSString* selTipoSinistro;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property BOOL editable;

-(id)initWithEventType:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext  andCanEdit:(BOOL)canEdit;

-(void) saveState;
-(void) rollbackState;

//- (IBAction)btnCancel:(id)sender;
- (IBAction)btnConcluido:(id)sender;

@end
