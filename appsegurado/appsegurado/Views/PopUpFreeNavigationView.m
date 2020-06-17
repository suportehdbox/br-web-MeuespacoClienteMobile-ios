//
//  PopUpFreeNavigationView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 16/06/17.
//  Copyright © 2017 Liberty Seguros. All rights reserved.
//

#import "PopUpFreeNavigationView.h"

@implementation PopUpFreeNavigationView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [_lblTitle setText:NSLocalizedString(@"NavegandoGratis", @"")];
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [_lblDescription setText:NSLocalizedString(@"NavegandoGratisDesc", @"")];
    [_lblDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblDescription setTextColor:[BaseView getColor:@"CinzaClaro"]];
    [_lblDescription setTextAlignment:NSTextAlignmentCenter];
    
    [_lblCheck setText:NSLocalizedString(@"NaoMostrarMais", @"")];
    [_lblCheck setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblCheck setTextColor:[BaseView getColor:@"CinzaEscuro"]];

    [_btOK setTitle:NSLocalizedString(@"BtPopUpSucesso", @"")  forState:UIControlStateNormal];
    
    [_check setOnTintColor:[BaseView getColor:@"CorBotoes"]];
    
    [_btOK setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btOK setBorderWidth:1];
    [_btOK setBorderRound:7];
    [_btOK setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btOK.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [BaseView addDropShadow:_bgPopUp];

}



@end
