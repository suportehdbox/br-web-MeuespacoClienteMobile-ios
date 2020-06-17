//
//  SecondPolicyView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/09/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "SecondPolicyView.h"

@implementation SecondPolicyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    
    
    [_lblTitle setText:NSLocalizedString(@"BaixarSegundaVia", @"")];
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    
  
    
    
    [_btShare setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btShare setBorderWidth:1];
    [_btShare setBorderRound:7];
    [_btShare setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btShare.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btShare setTitle:NSLocalizedString(@"BtCompartilhar", @"") forState:UIControlStateNormal];
    [_btShare setHidden:YES];
    
    
    
    [_btDownload setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btDownload setBorderWidth:1];
    [_btDownload setBorderRound:7];
    [_btDownload setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btDownload.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btDownload setTitle:NSLocalizedString(@"BtBaixar", @"") forState:UIControlStateNormal];
    [_btDownload setHidden:YES];
    
    [BaseView addDropShadow:_boxView];

    if (![Config isAliroProject]) {
        [_btShare setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_btShare setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btShare customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
        [_btDownload setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btDownload setBorderColor:[BaseView getColor:@"Verde"]];
        [_btDownload customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    

}

-(void) showLoading{
    [_activity startAnimating];
    [_activity setHidden:NO];
    [_lblTitle setHidden:YES];
    [_btShare setHidden:YES];
    [_btDownload setHidden:YES];
}

-(void) stopLoading{
    [_activity stopAnimating];
    [_activity setHidden:YES];
    [_lblTitle setHidden:NO];
    [_btShare setHidden:NO];
    [_btDownload setHidden:NO];
    
}
-(void) hidePopUp{
    [self stopLoading];
    [_boxView setHidden:YES];
}

@end
