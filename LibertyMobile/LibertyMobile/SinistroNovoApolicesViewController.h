//
//  SinistroNovoApolicesViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
#import "DadosLoginSegurado.h"
#import "Event.h"

@interface SinistroNovoApolicesViewController : UIViewController <UITextFieldDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView         * apolicesTableView;
    NSMutableArray      * apolices;
    NSDictionary        * selApolice;
    DadosLoginSegurado  *dadosLoginSegurado;
    
    IBOutlet UIImageView *imgApolice;
    IBOutlet UITextField *txtApolice;
    IBOutlet UILabel *lblApolice;
    
    IBOutlet UIActivityIndicatorView *indicator;

    UIAlertView *uiAlertView;
}

@property (nonatomic, retain) IBOutlet UITableView* apolicesTableView;
@property (nonatomic, retain) NSDictionary* selApolice;
@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;
@property (nonatomic, retain) IBOutlet UIImageView *imgApolice;
@property (nonatomic, retain) IBOutlet UITextField *txtApolice;
@property (nonatomic, retain) IBOutlet UILabel *lblApolice;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) UIAlertView *uiAlertView;

@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property BOOL editable;

-(id)initWithEvent:(Event *)eventInit andManagedObjectContext:(NSManagedObjectContext *)theManagedObjectContext andCanEdit:(BOOL)canEdit;

- (IBAction)btnSinistroNovo:(id)sender;
- (IBAction)btnConcluido:(id)sender;

@end
