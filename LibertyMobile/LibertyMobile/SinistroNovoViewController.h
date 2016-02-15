//
//  SinistroNovoViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SinistroNovoContatoViewController.h"
#import "SinistroNovoDataHoraViewController.h"
#import "SinistroNovoTipoSinistroViewController.h"
#import "SinistroNovoLocalViewController.h"
#import "SinistroNovoEnvolvidosViewController.h"
#import "SinistroNovoEnviarViewController.h"
#import "Event.h"
#import "DadosLoginSegurado.h"

@interface SinistroNovoViewController : UIViewController <UIActionSheetDelegate, SinistroNovoEnviarViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>
{
    UITableView *menuTableView;
    UIDatePicker *dtSinistro; 
    NSMutableArray *menuItens;
    DadosLoginSegurado *dadosLoginSegurado;

    BOOL pictures;
    BOOL subType;
    BOOL timeLocation;
    BOOL contactInfo;
    BOOL sharedInfo;
    BOOL textNote;
    BOOL voiceNote;
    BOOL userInfo;
    BOOL minimumReqs;
    
    BOOL editable;
}

@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) Event *event;
@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;
@property BOOL editable;

//- (IBAction)btnBack:(id)sender;
- (IBAction)btnEnviar:(id)sender;

@end
