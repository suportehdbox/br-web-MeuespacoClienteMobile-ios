//
//  MinhasApolicesDetalheViewController.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DadosLoginSegurado.h"


@interface MinhasApolicesDetalheViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    UIActivityIndicatorView *indicator;
    IBOutlet UITableView *tableDetalhes;
    
    NSMutableDictionary *cellDict;
    NSMutableArray *coberturas;
    
    BOOL bLoadDetalhes;
    NSInteger heightCellDetalhe;
    NSMutableString *descricaoCoberturas;
}


@property (nonatomic, retain) DadosLoginSegurado *dadosLoginSegurado;
@property (nonatomic, retain)NSMutableDictionary* cellDict;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *indicator;
@property (nonatomic, retain) IBOutlet UITableView *tableDetalhes;
@property (nonatomic) NSInteger heightCellDetalhe;
@property (nonatomic, retain) NSMutableString *descricaoCoberturas;

//- (IBAction)btnVoltar:(id)sender;
- (IBAction)btnParcelas_Click:(id)sender;

@end
