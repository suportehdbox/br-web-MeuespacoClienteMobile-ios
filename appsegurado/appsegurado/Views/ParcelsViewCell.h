//
//  ParcelsViewCell.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParcelsViewCell : UITableViewCell

@property (nonatomic,strong) IBOutlet UIView *bgView;
@property (nonatomic,strong) IBOutlet UILabel *lblNumParcel;
@property (nonatomic,strong) IBOutlet UILabel *lblDate;
@property (nonatomic,strong) IBOutlet UILabel *lblValue;
@property (nonatomic,strong) IBOutlet UILabel *lblStatus;


@end
