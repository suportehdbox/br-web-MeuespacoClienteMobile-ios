//
//  SecondPolicyView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/09/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "BaseView.h"

@interface SecondPolicyView : BaseView


@property (strong, nonatomic) IBOutlet UIView *boxView;
@property (strong, nonatomic) IBOutlet UILabel *lblTitle;
@property (strong, nonatomic) IBOutlet CustomButton *btShare;
@property (strong, nonatomic) IBOutlet CustomButton *btDownload;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;


-(void) loadView;
-(void) stopLoading;
-(void) showLoading;
-(void) hidePopUp;

@end
