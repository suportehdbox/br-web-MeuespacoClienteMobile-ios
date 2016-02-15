//
//  MinhasApolicesViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/30/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DadosLoginSegurado.h"

@interface MinhasApolicesViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView             *menuTableView;
    NSMutableArray          *apolices;
    UIActivityIndicatorView *indicator;
    
    BOOL                    bLoadApolicesVigentes;
    
    DadosLoginSegurado *dadosLoginSegurado;
}

@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

//- (IBAction)btnMenu:(id)sender;
- (IBAction)btnAnteriores_Click:(id)sender;

@end