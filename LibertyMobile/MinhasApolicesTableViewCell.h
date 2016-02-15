//
//  MinhasApolicesTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/31/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MinhasApolicesTableViewCell : UITableViewCell {
    IBOutlet UILabel* lblNumeroApolice;
    IBOutlet UILabel* lblDetalhe;
    IBOutlet UIImageView* imgAlerta;
}

@property (nonatomic, retain) IBOutlet UILabel* lblNumeroApolice;
@property (nonatomic, retain) IBOutlet UILabel* lblDetalhe;
@property (nonatomic, retain) IBOutlet UIImageView* imgAlerta;

@end
