//
//  OficinasReferenciadasTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/3/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface OficinasReferenciadasTableViewCell : UITableViewCell {
    UILabel* lblEstabelecimento;
    UILabel* lblEndereco;
    UILabel* lblBairroCidadeUF;
    UILabel* lblCEP;
    UILabel* lblKm;
}

@property (nonatomic, retain) IBOutlet UILabel* lblEstabelecimento;
@property (nonatomic, retain) IBOutlet UILabel* lblEndereco;
@property (nonatomic, retain) IBOutlet UILabel* lblBairroCidadeUF;
@property (nonatomic, retain) IBOutlet UILabel* lblCEP;
@property (nonatomic, retain) IBOutlet UILabel* lblKm;

@end
