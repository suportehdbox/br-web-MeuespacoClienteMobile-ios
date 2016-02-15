//
//  ClubeLibertyViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DadosLoginSegurado.h"

@interface ClubeLibertyViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* categoriasTableView;
    NSMutableArray * clubeLiberty;
    NSMutableArray * categorias;
    DadosLoginSegurado *dadosLoginSegurado;
    UIActivityIndicatorView *indicator;
}

@property (nonatomic, retain) IBOutlet UITableView* categoriasTableView;
@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;

//- (IBAction)btnMenu:(id)sender;

@end
