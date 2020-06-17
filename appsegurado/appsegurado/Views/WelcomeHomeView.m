//
//  WelcomeHomeView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "WelcomeHomeView.h"
#import <NSString+FontAwesome.h>

@implementation WelcomeHomeView
@synthesize btLoginLater,btPhone;

-(void) loadView{
    
    [_backgroundImage setImage:[UIImage imageNamed:@"bg_home.jpg"]];
    [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
//    UIImage *originalImage =  //[UIImage imageNamed:@"seta"];
//    UIImage *scaledImage =
//    [UIImage imageWithCGImage:[originalImage CGImage]
//                        scale:(originalImage.scale * 1.5)
//                  orientation:(originalImage.imageOrientation)];
    
    

    
    if ([Config isAliroProject]) {
        [self setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btRegister setTitleColor:[BaseView getColor:@"Verde"] forState:UIControlStateNormal];
        [_btRegister customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:10];
        [_btLogin customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [_btLogin customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
        [btLoginLater.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:11]];
        [btLoginLater setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAArrowLeft], NSLocalizedString(@"LogarDepois",@"") ] forState:UIControlStateNormal];
        [btLoginLater setTitleColor:[BaseView getColor:@"Branco"] forState:UIControlStateNormal];
        [btLoginLater customizeBorderColor:[BaseView getColor:@"Branco"] borderWidth:1 borderRadius:10];
    }else{
        [_backgroundImage setImage:[UIImage imageNamed:@"logo_liberty"]];
        [_backgroundImage setContentMode:UIViewContentModeCenter];
        [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:true]];
        [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Small bold:true]];
        [self setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_btRegister setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
        [_btRegister customizeBorderColor:[BaseView getColor:@"Branco"] borderWidth:1 borderRadius:10];
        [_btRegister customizeBackground:[BaseView getColor:@"Branco"]];
        [_btLogin customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [_btLogin customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:10];
        
//        [btLoginLater setImage:[self colorizeImage:scaledImage color:[BaseView getColor:@"AzulEscuro"]] forState:UIControlStateNormal];
//        [btLoginLater setTintColor:[BaseView getColor:@"AzulEscuro"]];
        [btLoginLater.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:11]];
//        [btLoginLater setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [btLoginLater setTitle:[NSString stringWithFormat:@"%@ %@",[NSString fontAwesomeIconStringForEnum:FAArrowLeft], NSLocalizedString(@"LogarDepois",@"") ] forState:UIControlStateNormal];

        [btLoginLater setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
        [btLoginLater customizeBackground:[BaseView getColor:@"Branco"]];
        [btLoginLater customizeBorderColor:[BaseView getColor:@"Branco"] borderWidth:1 borderRadius:10];
        
        [btPhone customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [btPhone customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:10];
        
        
    }
    

}


-(void) updateBackgroundImage:(UIImage *)image{
    if ([Config isAliroProject]) {
        if(image == nil){
            return;
        }
        dispatch_async (dispatch_get_main_queue(), ^{
            [_backgroundImage setImage:image];
        });
    }
}
@end
