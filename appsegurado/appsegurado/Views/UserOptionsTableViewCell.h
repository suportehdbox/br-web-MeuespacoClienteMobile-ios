//
//  UserOptionsTableViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 07/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserOptionsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIImageView *imgOption;
@property (strong, nonatomic) IBOutlet UIView *divisor;

@end
