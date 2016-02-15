//
//  SinistroConsultaTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/6/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface SinistroConsultaTableViewCell : UITableViewCell {
    UILabel* lblEnviado;
    UILabel* lblTipo;
    UILabel* lblData;
    UILabel* lblLocal;
}

@property(nonatomic,retain)IBOutlet UILabel* lblEnviado;
@property(nonatomic,retain)IBOutlet UILabel* lblTipo;
@property(nonatomic,retain)IBOutlet UILabel* lblData;
@property(nonatomic,retain)IBOutlet UILabel* lblLocal;

@end
