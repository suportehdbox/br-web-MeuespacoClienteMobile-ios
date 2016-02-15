//
//  ClubeLibertyLocaisViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClubeLibertyLocaisViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UITableView* locaisTableView;

    NSMutableArray *clubeLiberty;   //Array iniciado na tela de categorias
    NSString *categoria;            //String de categoria para filtragem
    NSMutableArray *locais;         //Array iniciado e populado a partir do Array de categorias
}

@property (nonatomic, retain) IBOutlet UITableView* locaisTableView;
@property (nonatomic, retain) NSMutableArray *clubeLiberty;
@property (nonatomic, retain) NSString *categoria;

//- (IBAction)btnVoltar:(id)sender;

@end
