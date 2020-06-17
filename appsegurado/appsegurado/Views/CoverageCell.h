//
//  CoverageCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/04/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CoverageCell : UITableViewCell
@property (nonatomic,strong) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) IBOutlet UILabel *lblValue;
@property (nonatomic,strong) IBOutlet UIImageView *imgTitle;
@property (nonatomic,strong) IBOutlet UILabel *txtDetail;
@property (nonatomic,strong) IBOutlet UIView *bgView;
@property (nonatomic) BOOL isTitle;
@end
