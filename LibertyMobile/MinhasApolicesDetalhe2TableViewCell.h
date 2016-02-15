//
//  MinhasApolicesDetalheTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 11/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MinhasApolicesDetalhe2TableViewCell : UITableViewCell
{
    IBOutlet UILabel* lblStatusPagamento;
    IBOutlet UILabel* lblStatusParcelas;
}

@property (nonatomic, retain) IBOutlet UILabel* lblStatusPagamento;
@property (nonatomic, retain) IBOutlet UILabel* lblStatusParcelas;

@end
