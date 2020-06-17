//
//  MenuTableViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *imgIcon;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblNumNotifications;


-(void)setBackgroundCellColor:(UIColor *)backgroundColor;
@end
