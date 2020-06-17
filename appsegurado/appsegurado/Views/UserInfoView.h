//
//  UserInfoView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 07/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UserInfoView : UIView

@property (strong, nonatomic) IBOutlet UILabel *lblName;
@property (strong, nonatomic) IBOutlet UILabel *lblEmail;
@property (strong, nonatomic) IBOutlet UIImageView *imgPhoto;
@property (strong, nonatomic) IBOutlet UILabel *lblMsg;
-(void) loadView;
-(void) loadViewHome;
@end
