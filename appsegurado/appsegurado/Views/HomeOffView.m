//
//  HomeOffView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 24/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "HomeOffView.h"
#import "MapPin.h"
@implementation HomeOffView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(_btRegister.frame) + 10)];
    [_scrollView setFrame:self.frame];
    
    [_lblMessage setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblMessage setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblMessage setTextAlignment:NSTextAlignmentCenter];
    
    [_btAccident displayButtonWithTitle:@"" titleColor:[BaseView getColor:@"Laranja"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
    
    [_btAutoWorkShops displayButtonWithTitle:@"" titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
    
    [_btClub displayButtonWithTitle:@"" titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
    
    
    [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btLogin customizeBackground:[BaseView getColor:@"CorBotoes"]];
    [_btLogin setTitle:NSLocalizedString(@"Logar", @"") forState:UIControlStateNormal ];
    [_btLogin customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
    
    [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btRegister customizeBackground:[BaseView getColor:@"Branco"]];
    [_btRegister setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal ];
    [_btRegister setTitle:NSLocalizedString(@"Cadastrar", @"") forState:UIControlStateNormal ];
    [_btRegister customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
    
    if([Config isAliroProject]){
        _posXButtonAssist.constant = -_AutoWorkShopView.frame.size.width * (1.0f - 0.30);
        _posXButtonAutoWork.constant = -_AutoWorkShopView.frame.size.width * (1.0f - 0.70);
        [_btAccident displayButtonWithTitle:NSLocalizedString(@"SinistroAssitencia", @"") titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Micro bold:NO]];
        
        [_btAutoWorkShops displayButtonWithTitle:NSLocalizedString(@"OficinasReferenciadas", @"") titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Micro bold:NO]];
        
        [_btClub setHidden:YES];
    }else{
        [_btAccident displayButtonWithTitle:@"" titleColor:[BaseView getColor:@"Laranja"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
        
        [_btAutoWorkShops displayButtonWithTitle:@"" titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
        
        [_btClub displayButtonWithTitle:@"" titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
        
        _posXButtonAssist.constant = -_AutoWorkShopView.frame.size.width * (1.0f - 0.20);
        _posXButtonAutoWork.constant = -_AutoWorkShopView.frame.size.width * (1.0f - 0.50);
        _posXButtonClub.constant = -_AutoWorkShopView.frame.size.width * (1.0f - 0.80);

        [_btLogin setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_btLogin setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btLogin customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
        [_btLogin setTitleColor:[BaseView getColor:@"AzulLogin"] forState:UIControlStateNormal];
        [_btRegister setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btRegister setBorderColor:[BaseView getColor:@"Verde"]];
        [_btRegister customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
        
    }
    
    [_mapViewWidth setConstant:self.frame.size.width];
    CGRect windowRect = self.window.frame;
    if(windowRect.size.height <= 568){
        [_spaceBotToBts setConstant:10];
        [_spaceBtsToLogin setConstant:10];
    }
    
    


}

-(void) showMessage:(NSString *)message{
    [_lblMessage setText:message];
    [_lblMessage setHidden:NO];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_imgLogo setHidden:YES];
    [_mapView setHidden:YES];
    [_btRegister setHidden:NO];
    [_btLogin setHidden:NO];
    if(![Config isAliroProject]){
        [_btClub setHidden:NO];
    }
    [_btAutoWorkShops setHidden:NO];
    [_btAccident setHidden:NO];
}

-(void) hideMessage{
    [_lblMessage setHidden:YES];
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
}

-(void) showAutoWorksMap:(NSMutableArray*) autoWorks{
    [self hideMessage];
    MapPin *near = [autoWorks objectAtIndex:0];
    [_AutoWorkShopView loadView:near.autoWork.indication];
    [_AutoWorkShopView setName:near.autoWork.name];
    [_AutoWorkShopView setAddress:near.autoWork.address];
    [_AutoWorkShopView setPhoneNumber:near.autoWork.phone];
    [_AutoWorkShopView setDistance:near.autoWork.distance];
    [_AutoWorkShopView setLatitude:[NSString stringWithFormat:@"%f",near.autoWork.coordinate.latitude]];
    [_AutoWorkShopView setLongitude:[NSString stringWithFormat:@"%f",near.autoWork.coordinate.longitude]];
    [_AutoWorkShopView addBoxTitle:NSLocalizedString(@"TituloOficinaProxima", @"")];
    [_AutoWorkShopView setOfficeHours:[near.autoWork getWorkingHoursPhrase]];
    [_AutoWorkShopView setHidden:NO];
    [_mapView addAnnotation:near];
    [_mapView setHidden:NO];
    [_mapView setShowsUserLocation:YES];
    [_mapView setRegion:MKCoordinateRegionMakeWithDistance(near.coordinate, 500, 500)];
}

-(UIAlertController *) showLocationNotFound{
    [self hideMessage];
    [_AutoWorkShopView setHidden:YES];
    [_mapView setHidden:YES];
    [_imgLogo setHidden:NO];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"TituloErroLocalizacao", @"")
                                          message:NSLocalizedString(@"ErroLocalizacao", @"")
                                          preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *okAction = [UIAlertAction
                               actionWithTitle:NSLocalizedString(@"BtPopUpSucesso", @"")
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction *action)
                               {
                                   NSLog(@"OK action");
                               }];
    
    [alertController addAction:okAction];
    
    return alertController;
}
@end
