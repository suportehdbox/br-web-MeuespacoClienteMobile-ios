//
//  AutoWorkShopView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 31/08/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AutoWorkShopView.h"
#import "MapPin.h"
@interface AutoWorkShopView(){
    NSMutableArray *currentAnnotations;
}
@end
@implementation AutoWorkShopView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [_popupView loadPopUp];
    [_popupGPSOff loadPopUp];
    [_popupGPSOff setTitleText:NSLocalizedString(@"ErroLocalizacao", @"")];
    [_lblMessage setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblMessage setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblMessage setTextAlignment:NSTextAlignmentCenter];
    
    [_btOtherPlace setTitle:NSLocalizedString(@"BotaoLocalizarOutroEndereco", @"") forState:UIControlStateNormal];
    [_btOtherPlace.titleLabel setFont:[BaseView getDefatulFont:Micro bold:false]];
    [_btOtherPlace setTitleColor:[BaseView getColor:@"Branco"] forState:UIControlStateNormal];
    [_btOtherPlace customizeBackground:[BaseView getColor:@"AzulLogin"]];
    [_btOtherPlace customizeBorderColor:[BaseView getColor:@"AzulLogin"] borderWidth:1 borderRadius:15];
    
    [_btOrdering setTitle:NSLocalizedString(@"BotaoLocalizarOrdenar", @"") forState:UIControlStateNormal];
    [_btOrdering.titleLabel setFont:[BaseView getDefatulFont:Micro bold:false]];
    [_btOrdering setTitleColor:[BaseView getColor:@"Branco"] forState:UIControlStateNormal];
    [_btOrdering customizeBackground:[BaseView getColor:@"AzulLogin"]];
    [_btOrdering customizeBorderColor:[BaseView getColor:@"AzulLogin"] borderWidth:1 borderRadius:15];
    
    [_mapView setShowsUserLocation:YES];
    
    [_tableView setHidden:YES];

}

-(void) unloadView{
    [_popupView unRegisterKeyboard];
    [_popupGPSOff unRegisterKeyboard];
}

-(void) hideKeyboard{
    [_popupView hideKeyboard];
    [_popupGPSOff hideKeyboard];

}

-(void) showPopUpSearch{
    [_popupView show];
}

-(void) hidePopUpSearch{
    [_popupView hide];
    [_popupGPSOff hide];
}

-(void) hideMessage{
    [_tableView setHidden:NO];
    [_lblMessage setHidden:YES];
    [_btOrdering setHidden:NO];
    [_btOtherPlace setHidden:NO];
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
}
-(void) showMessage:(NSString *)message{
    [_lblMessage setHidden:NO];
    [_lblMessage setText:message];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_tableView setHidden:YES];
    [_btOrdering setHidden:YES];
    [_btOtherPlace setHidden:YES];
}


-(UIAlertController *) showLocationNotFound{
    [self hideMessage];
//    
//    UIAlertController *alertController = [UIAlertController
//                                          alertControllerWithTitle:NSLocalizedString(@"TituloErroLocalizacao", @"")
//                                          message:NSLocalizedString(@"ErroLocalizacao", @"")
//                                          preferredStyle:UIAlertControllerStyleAlert];
//    UIAlertAction *okAction = [UIAlertAction
//                               actionWithTitle:NSLocalizedString(@"Ok", @"")
//                               style:UIAlertActionStyleDefault
//                               handler:^(UIAlertAction *action)
//                               {
//                                   NSLog(@"OK action");
//                               }];
//    
//    [alertController addAction:okAction];
//    
//    return alertController;
    
    [_popupGPSOff setTitleText:NSLocalizedString(@"ErroLocalizacao", @"")];
    [_popupGPSOff show];
    return nil;
}


-(UIAlertController *) showNetworkError{
    [self hideMessage];
    //
    //    UIAlertController *alertController = [UIAlertController
    //                                          alertControllerWithTitle:NSLocalizedString(@"TituloErroLocalizacao", @"")
    //                                          message:NSLocalizedString(@"ErroLocalizacao", @"")
    //                                          preferredStyle:UIAlertControllerStyleAlert];
    //    UIAlertAction *okAction = [UIAlertAction
    //                               actionWithTitle:NSLocalizedString(@"Ok", @"")
    //                               style:UIAlertActionStyleDefault
    //                               handler:^(UIAlertAction *action)
    //                               {
    //                                   NSLog(@"OK action");
    //                               }];
    //
    //    [alertController addAction:okAction];
    //
    //    return alertController;
    
    [_popupGPSOff setTitleText:NSLocalizedString(@"ErroConexao", @"")];
    [_popupGPSOff show];
    return nil;
}

-(UIAlertController *) showErrorSearch{
    [self hideMessage];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"TituloErroCampos", @"")
                                          message:NSLocalizedString(@"ErroCampos", @"")
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
-(UIAlertController *) showErrorApp:(NSString*) appName{
    [self hideMessage];
    
    UIAlertController *alertController = [UIAlertController
                                          alertControllerWithTitle:NSLocalizedString(@"ErrorTitle", @"")
                                          message:[NSString stringWithFormat:NSLocalizedString(@"ErroAbrirApp", @""), appName]
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


-(void) showAutoWorksMap:(NSMutableArray*) autoWorks{
    if([autoWorks count] > 0){
        [self hideMessage];
        
        if(currentAnnotations != nil && [currentAnnotations count] > 0){
            [_mapView removeAnnotations:currentAnnotations];
        }
        currentAnnotations = autoWorks;
        for ( MapPin *near in autoWorks) {
            [_mapView addAnnotation:near];
            [_mapView setHidden:NO];
        }
        [self centerMapToUser];
        [_tableView reloadData];
    }else{
        [_popupGPSOff setTitleText:NSLocalizedString(@"ErroNenhumaOficina", @"")];
        [_popupGPSOff show];
        
    }

}

-(void) centerMapToUser{
    if(_mapView.userLocation.coordinate.latitude == 0 && _mapView.userLocation.coordinate.longitude == 0){
        [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(centerMapToUser) userInfo:nil repeats:NO];
    }else{
        [_mapView setRegion:MKCoordinateRegionMakeWithDistance(_mapView.userLocation.coordinate, 500, 500)];
    }
}



-(void) showPopUpInfo{
    [_lblInfo setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblInfo setTextColor:[BaseView getColor:@"Verde"]];
    [_lblInfo setText:NSLocalizedString(@"ConhecaVantagens", @"")];
    [_lblInfo setTextAlignment:NSTextAlignmentLeft];
    
    if ([ [ UIScreen mainScreen ] bounds ].size.height >= 568){
        [_lblDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
    }else{
        [_lblDescription setFont:[BaseView getDefatulFont:Nano bold:NO]];
    }
    [_lblDescription setTextColor:[BaseView getColor:@"Branco"]];
    [_lblDescription setText:NSLocalizedString(@"DescricaoVantagens", @"")];

    [_btOkPopUpInfo setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    
    if(![Config isAliroProject]){
        [_btOkPopUpInfo setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btOkPopUpInfo setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btOkPopUpInfo setBorderColor:[BaseView getColor:@"Verde"]];
        [_btOkPopUpInfo customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    
    [_popupInfo setHidden:NO];

}

-(void) hidePopUpInfo{
    [_popupInfo setHidden:YES];
}

-(void) setNearest{
    [_btOrdering setTitle:NSLocalizedString(@"BotaoLocalizarOrdenar", @"") forState:UIControlStateNormal];
}
-(void) setScore{
    [_btOrdering setTitle:NSLocalizedString(@"BotaoLocalizarOrdenarRecomendadas", @"") forState:UIControlStateNormal];
}

-(float) rowHeight{
    return 170.0f;

}


-(void) reloadTable{
    [_tableView reloadData];
}

@end

