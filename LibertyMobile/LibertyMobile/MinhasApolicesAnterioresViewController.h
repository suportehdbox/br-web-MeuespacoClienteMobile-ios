//
//  MinhasApolicesAnterioresViewController
//  LibertyMobile
//
//  Created by Evandro Oliverira on 23/07/13.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DadosLoginSegurado.h"

@interface MinhasApolicesAnterioresViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    IBOutlet UITableView* menuTableView;
    NSMutableArray * apolicesAnteriores;
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;
@property (nonatomic, retain) IBOutlet UITableView *menuTableView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

//- (IBAction)btnVoltar:(id)sender;

@end
