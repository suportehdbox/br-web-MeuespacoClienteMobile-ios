//
//  PolicyViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomButton.h"

@interface PolicyViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *iconPolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicy;
@property (strong, nonatomic) IBOutlet UIImageView *iconType;
@property (strong, nonatomic) IBOutlet UILabel *lblType;
@property (strong, nonatomic) IBOutlet UILabel *lblValueType;
@property (strong, nonatomic) IBOutlet CustomButton *btLoadOldPolices;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;
@property (strong, nonatomic) IBOutlet UIView *viewContainer;

@end
