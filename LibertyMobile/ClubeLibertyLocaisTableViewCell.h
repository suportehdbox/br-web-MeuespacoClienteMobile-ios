//
//  ClubeLibertyLocaisTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/4/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface ClubeLibertyLocaisTableViewCell : UITableViewCell {
    UIImageView* imgLogo;
    UILabel* lblNome;
    UILabel* lblEndereco;
    UILabel* lblBairroCidadeUF;
}

@property (nonatomic, retain) IBOutlet UIImageView* imgLogo;
@property (nonatomic, retain) IBOutlet UILabel* lblNome;
@property (nonatomic, retain) IBOutlet UILabel* lblEndereco;
@property (nonatomic, retain) IBOutlet UILabel* lblBairroCidadeUF;

@end
