//
//  ContactTableViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContactTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UIButton *btPhone;
@property (strong, nonatomic) IBOutlet UILabel *lblHours;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle2;
@property (strong, nonatomic) IBOutlet UIButton *btPhone2;
@property (strong, nonatomic) IBOutlet UIButton *btSkype;
@property (strong, nonatomic) IBOutlet UILabel *lblHours2;
@property (strong, nonatomic) IBOutlet UIView *divisor;
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightHours2;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightHours;

@end
