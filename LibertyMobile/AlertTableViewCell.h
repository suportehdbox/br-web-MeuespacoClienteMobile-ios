//
//  AlertTableViewCell.h
//  LibertyMobile
//
//  Created by Fernando Balthazar on 9/22/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AlertTableViewCell : UITableViewCell {
    IBOutlet UILabel* lblInfo;
    IBOutlet UIImageView* imgAlert;
}

@property (nonatomic, retain) IBOutlet UILabel* lblInfo;
@property (nonatomic, retain) IBOutlet UIImageView* imgAlert;

@end
