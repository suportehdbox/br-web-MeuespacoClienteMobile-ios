//
//  WelcomeHomeView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 23/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "WelcomeHomeView.h"
#import <NSString+FontAwesome.h>

@implementation WelcomeHomeView @synthesize btLoginLater, btPhone;

- (void) loadView {

    [_backgroundImage setImage:[UIImage imageNamed:@"bg_home.jpg"]];
    [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];

    if ([Config isAliroProject]) {
        [_btRegister setTitleColor:[BaseView getColor:@"Verde"] forState:UIControlStateNormal];
        [_btRegister customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:10];
        [_btLogin customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [_btLogin customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
        [btLoginLater.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:16]];
        [btLoginLater setTitle:
         [NSString stringWithFormat:
          @"%@ %@", [NSString fontAwesomeIconStringForEnum:FAArrowLeft], NSLocalizedString(@"LogarDepois", @"")]
                      forState:UIControlStateNormal];
        [btLoginLater setTitleColor:[BaseView getColor:@"Branco"] forState:UIControlStateNormal];
        [btLoginLater customizeBorderColor:[BaseView getColor:@"Branco"] borderWidth:1 borderRadius:10];
        [_btContato customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [_btContato customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:10];
        [_btContato.titleLabel setFont:[BaseView getDefatulFont:Small bold:true]];
    } else {
        [self setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_backgroundImage setImage:[UIImage imageNamed:@"logo_liberty"]];
        [_backgroundImage setContentMode:UIViewContentModeCenter];
        [_btRegister customizeBorderColor:[BaseView getColor:@"Branco"] borderWidth:1 borderRadius:10];
        [_btRegister customizeBackground:[BaseView getColor:@"Branco"]];
        [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Small bold:true]];
        [_btRegister setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
        [_btLogin customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [_btLogin customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:10];
        [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:true]];
        [_btContato customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [_btContato customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:10];
        [_btContato.titleLabel setFont:[BaseView getDefatulFont:Small bold:true]];

        //        [btLoginLater setImage:[self colorizeImage:scaledImage color:[BaseView getColor:@"AzulEscuro"]] forState:UIControlStateNormal];
        //        [btLoginLater setTintColor:[BaseView getColor:@"AzulEscuro"]];
        [btLoginLater.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:16]];
        //        [btLoginLater setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
        [btLoginLater setTitle:[NSString stringWithFormat:@"%@ %@", [NSString fontAwesomeIconStringForEnum:FAArrowLeft], NSLocalizedString(@"LogarDepois", @"")] forState:UIControlStateNormal];

        [btLoginLater setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
        [btLoginLater customizeBackground:[BaseView getColor:@"Branco"]];
        [btLoginLater customizeBorderColor:[BaseView getColor:@"Branco"] borderWidth:1 borderRadius:10];

        [btPhone customizeBackground:[BaseView getColor:@"CorBotoes"]];
        [btPhone customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:10];
    }
} /* loadView */

- (void) updateBackgroundImage: (UIImage *)image {
    if ([Config isAliroProject]) {
        if (image == nil) {
            return;
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self->_backgroundImage setImage:image];
        });
    }
}

- (IBAction) openWhatsApp {
    NSURLComponents * comps = [NSURLComponents componentsWithString:@"https://api.whatsapp.com/send"];

    [comps setQueryItems:@[[NSURLQueryItem queryItemWithName:@"phone" value:@"+551132061414"],
                           [NSURLQueryItem queryItemWithName:@"text" value:@"Oi liberty, tudo bem?"]]];
//    NSURL * sda = [NSURL URLWithString: @"https://api.whatsapp.com/send?1=pt_BR&phone=551132061414&text=Oi%20Liberty,%20Tudo%20Bem%20"];
    [UIApplication.sharedApplication openURL:[comps URL]];
}

@end
