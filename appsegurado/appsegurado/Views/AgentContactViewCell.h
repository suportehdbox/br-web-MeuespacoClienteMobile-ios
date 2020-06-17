//
//  AgentContactViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AgentContactViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicy;
@property (strong, nonatomic) IBOutlet UIView *divisor;
@property (strong, nonatomic) IBOutlet UIButton *btMail;
@property (strong, nonatomic) IBOutlet UIButton *btPhone;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightPolicy;



@end
