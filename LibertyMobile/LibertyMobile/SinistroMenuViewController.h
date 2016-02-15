//
//  SinistroMenuViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/29/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Util.h"
#import "SinistroConsultaViewController.h"
#import "DadosLoginSegurado.h"

@interface SinistroMenuViewController : UIViewController  <UITableViewDataSource, UITableViewDelegate, SinistroConsultaViewControllerDelegate>
{
    UITableView         * menuTableView;
    NSMutableArray      * menuItens;
    DadosLoginSegurado  * dadosLoginSegurado;
}

@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (nonatomic, retain) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, assign) NSUInteger iCountEvents;
@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;

- (NSInteger)getCountEvents;
//- (IBAction)btnMenu:(id)sender;

@end
