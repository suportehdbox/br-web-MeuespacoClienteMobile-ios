//
//  AccidentView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 02/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "AccidentView.h"

@implementation AccidentView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) loadView :(BOOL) userLogged{

    
    [_btStatusClaim.titleLabel setTextAlignment:NSTextAlignmentCenter];
    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"TipoAtendimento", @"")];

    [_lblSubTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblSubTitle setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblSubTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblSubTitle setText:NSLocalizedString(@"EscolhaAtendimento", @"")];
    
//    [_btSinister displayButtonWithTitle:NSLocalizedString(@"SinistroAssitencia",@"") titleColor:[BaseView getColor:@"Laranja"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
//    [_btSinister setHidden:NO];
//
//    
//    [_bt24Assist displayButtonWithTitle:NSLocalizedString(@"BotaoAsistencia24",@"") titleColor:[BaseView getColor:@"Laranja"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
//    [_bt24Assist setHidden:NO];
    [_btSinister setImage:[UIImage imageNamed:@"btSinister.png"] forState:UIControlStateNormal];
    [_bt24Assist setImage:[UIImage imageNamed:@"btAssist24.png"] forState:UIControlStateNormal];
    
    
    [_btGlassAssist setImage:[UIImage imageNamed:@"icon_oval_glass.png"] forState:UIControlStateNormal];
    
    
    [_btMyAssistances setTitle:[NSLocalizedString(@"MyFiles", @"")uppercaseString] forState:UIControlStateNormal];
    [_btMyAssistances customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
    [_btMyAssistances setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btMyAssistances.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    [_btStatusClaim setTitle:[NSLocalizedString(@"MyClaims", @"") uppercaseString] forState:UIControlStateNormal];
    [_btStatusClaim customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
    [_btStatusClaim setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btStatusClaim.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    
    
    
    
    [_lblMyAssistances setText:NSLocalizedString(@"AcompanharAtendimento", @"") ];
    [_lblMyAssistances setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblMyAssistances setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblMyAssistances setTextAlignment:NSTextAlignmentLeft];
    
    [_lblFooter setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblFooter setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblFooter setTextAlignment:NSTextAlignmentRight];
    [_lblFooter setText:NSLocalizedString(@"EstouComDuvidas", @"")];
    

    [_btHelp setTintColor:[BaseView getColor:@"AzulEscuro"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FaleComLiberty", @"")];
    [title addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    [title addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    //addAttribute:
    [_btHelp setAttributedTitle:title forState:UIControlStateNormal];
    [_btHelp.titleLabel setFont:[BaseView getDefatulFont:Micro bold:NO]];
    
    
    
    
//    NSMutableAttributedString *claim2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"CliqueAqui", @"")];
//    [claim2 addAttribute:NSUnderlineColorAttributeName
//                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"CliqueAqui", @"") length])];
//    [claim2 addAttribute:NSUnderlineStyleAttributeName
//                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"CliqueAqui", @"") length])];
//    [claim2 addAttribute:NSForegroundColorAttributeName
//                   value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"CliqueAqui", @"") length])];
//    [claim2 addAttribute:NSFontAttributeName
//                   value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, [NSLocalizedString(@"CliqueAqui", @"") length])];
//
//    NSMutableAttributedString *claim1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"JaPossuiSinistro", @"")];
//    [claim1 addAttribute:NSForegroundColorAttributeName
//                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"JaPossuiSinistro", @"") length])];
//    [claim1 addAttribute:NSFontAttributeName
//                   value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"JaPossuiSinistro", @"") length])];
//
//    NSMutableAttributedString *claimFinal = [[NSMutableAttributedString alloc] initWithAttributedString:claim1];
//    [claimFinal appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"] ];
//    [claimFinal appendAttributedString:claim2];
//    [_btStatusClaim.titleLabel setNumberOfLines:2];
//    [_btStatusClaim.titleLabel setTextAlignment:NSTextAlignmentCenter];
//    [_btStatusClaim setAttributedTitle:claimFinal forState:UIControlStateNormal];
    
    [_btStatusClaim setHidden:!userLogged];
    [_btMyAssistances setHidden:YES];
    [_lblMyAssistances setHidden:YES];
    

    
//    if([Config isAliroProject]){
//        [_btMyAssistances setHidden:true];
//        [_bt24Assist setHidden:true];
//        _sinister_const.constant = -self.frame.size.width * (1.0f - 0.33);
//        //    _posXButtonAutoWork.constant = self.frame.size.width * (1.0f - 0.50);
//        _glass_assist_const.constant = -self.frame.size.width * (1.0f - 0.66);
//
//    }else{
        _sinister_const.constant = -self.frame.size.width * (1.0f - 0.20);
        //    _posXButtonAutoWork.constant = self.frame.size.width * (1.0f - 0.50);
        _glass_assist_const.constant = -self.frame.size.width * (1.0f - 0.80);
        
        
    
        [_btStatusClaim setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btStatusClaim customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
        [_btMyAssistances setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btMyAssistances setBorderColor:[BaseView getColor:@"Verde"]];
        [_btMyAssistances customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    if ([Config isAliroProject]) {
        [_btStatusClaim setBackgroundColor:[BaseView getColor:@"Branco"]];
    }else{
        [_btStatusClaim setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    
//    }

    [self updateConstraintsIfNeeded];

}

@end
