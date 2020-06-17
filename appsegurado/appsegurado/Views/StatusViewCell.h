//
//  StatusViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StatusViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UIImageView *iconPolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblTitlePolicy;
@property (strong, nonatomic) IBOutlet UILabel *lblPolicy;
@property (strong, nonatomic) IBOutlet UIImageView *iconStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblStatus;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleClaim;
@property (strong, nonatomic) IBOutlet UILabel *lblNumber;
@property (strong, nonatomic) IBOutlet UILabel *lblTitleDate;
@property (strong, nonatomic) IBOutlet UILabel *lblDate;
@property (strong, nonatomic) IBOutlet UIButton *btOpenUpload;
@property (strong, nonatomic) IBOutlet UILabel *lblUpload;

@end
