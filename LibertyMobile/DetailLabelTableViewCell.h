//
//  DetailLabelTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface DetailLabelTableViewCell : UITableViewCell {
    IBOutlet UILabel* lblMenuItem;
    IBOutlet UILabel* lblTextInfo;
}

@property(nonatomic,retain)IBOutlet UILabel* lblMenuItem;
@property(nonatomic,retain)IBOutlet UILabel* lblTextInfo;

@end
