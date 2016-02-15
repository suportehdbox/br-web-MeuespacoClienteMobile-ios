//
//  MinhasApolicesDetalheTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinhasApolicesDetalheTableViewCell : UITableViewCell
{
    IBOutlet UILabel* lblNumeroApolice;
    IBOutlet UILabel* lblCoberturas;
    IBOutlet UILabel* lblVigencia;
}

@property (nonatomic, retain) IBOutlet UILabel* lblNumeroApolice;
@property (nonatomic, retain) IBOutlet UILabel* lblCoberturas;
@property (nonatomic, retain) IBOutlet UILabel* lblVigencia;

@end
