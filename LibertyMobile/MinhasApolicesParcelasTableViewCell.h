//
//  MinhasApolicesParcelasTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MinhasApolicesParcelasTableViewCell : UITableViewCell {
    IBOutlet UILabel* lblParcela;
    IBOutlet UILabel* lblVencimento;
    IBOutlet UILabel* lblValor;
    IBOutlet UILabel* lblStatus;
}

@property (nonatomic, retain) IBOutlet UILabel* lblParcela;
@property (nonatomic, retain) IBOutlet UILabel* lblVencimento;
@property (nonatomic, retain) IBOutlet UILabel* lblValor;
@property (nonatomic, retain) IBOutlet UILabel* lblStatus;


@end
