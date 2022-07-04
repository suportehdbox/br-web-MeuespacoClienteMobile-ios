//
//  WelcomeHomeView.h
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseView.h"


@interface WelcomeHomeView : BaseView
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (strong, nonatomic) IBOutlet CustomButton *btLogin;
@property (strong, nonatomic) IBOutlet CustomButton *btRegister;
@property (strong, nonatomic) IBOutlet UILabel *lbContato;
@property (strong, nonatomic) IBOutlet CustomButton *btContato;


-(void) loadView;
-(void) updateBackgroundImage:(UIImage *)image;
-(IBAction)openWhatsApp;
@end
