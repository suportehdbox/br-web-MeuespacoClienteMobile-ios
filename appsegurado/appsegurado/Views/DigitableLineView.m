//
//  DigitableLineView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/03/18.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "DigitableLineView.h"
@interface DigitableLineView(){
    
    NSString *currentDate;
    NSString *currentValue;
}
@end
@implementation DigitableLineView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
-(void) loadView{
    
    
    [_lblTitle setText:NSLocalizedString(@"ProrrogarPagamento", @"")];
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentCenter];
    
    [_lblInstructions1 setText:NSLocalizedString(@"ProrrogarDesc1", @"")];
    [_lblInstructions1 setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructions1 setTextColor:[BaseView getColor:@"CinzaClaro"]];
    [_lblInstructions1 setNumberOfLines:0];
    
    [_lblPaymentInstructions setText:NSLocalizedString(@"ProrrogarDesc2", @"")];
    [_lblPaymentInstructions setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblPaymentInstructions setTextColor:[BaseView getColor:@"CinzaClaro"]];
    [_lblPaymentInstructions setNumberOfLines:0];

    [_lblDateAndPayment setNumberOfLines:0];
    [_lblDateAndPayment setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblDateAndPayment setTextColor:[BaseView getColor:@"Verde"]];
    
    
    
    [_btAgreed setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btAgreed setBorderWidth:1];
    [_btAgreed setBorderRound:7];
    [_btAgreed setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btAgreed.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btAgreed setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    [_btAgreed setHidden:YES];
    
    
    
    [_btCopyCode setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btCopyCode setBorderWidth:1];
    [_btCopyCode setBorderRound:7];
    [_btCopyCode setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btCopyCode.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btCopyCode setTitle:NSLocalizedString(@"CopiarBoleto", @"") forState:UIControlStateNormal];
    [_btCopyCode setHidden:YES];
    
    [BaseView addDropShadow:_boxView];
    
    
    
    NSMutableAttributedString * btTermsTitle  = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"InstrucaoCompleta", @"")];
    [btTermsTitle addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, btTermsTitle.length)];
    [btTermsTitle addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, btTermsTitle.length)];
    [btTermsTitle addAttribute:NSUnderlineColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, btTermsTitle.length)];
    [btTermsTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, btTermsTitle.length)];
    [_btTerms setAttributedTitle:btTermsTitle forState:UIControlStateNormal];
    
   
    currentDate = @"";
    currentValue = @"";
    
}

-(void) showLoading{
    [_activity startAnimating];
    [_activity setHidden:NO];
    
    [_lblTitle setHidden:YES];
    [_lblInstructions1 setHidden:YES];
    [_lblPaymentInstructions setHidden:YES];
    [_lblDateAndPayment setHidden:YES];
    [_btAgreed setHidden:YES];
    [_btCopyCode setHidden:YES];
    [_line1 setHidden:YES];
    [_line2 setHidden:YES];
    [_btTerms setHidden:YES];
}

-(void) stopLoading{
    [_activity stopAnimating];
    [_activity setHidden:YES];
    [_btTerms setHidden:NO];
    [_lblTitle setHidden:NO];
    [_lblInstructions1 setHidden:NO];
    [_lblPaymentInstructions setHidden:NO];
    [_lblDateAndPayment setHidden:NO];
    [_line1 setHidden:NO];
    [_line2 setHidden:NO];
    [_btCopyCode setHidden:NO];
    [_btAgreed setHidden:NO];
 
}
-(void) hidePopUp{
    [self stopLoading];
    [_boxView setHidden:YES];
}
-(void) setCodeCopied{
    [_btCopyCode setTitle:NSLocalizedString(@"TextoCopiado", @"") forState:UIControlStateNormal];
    
}
-(void) setBtSantander{
    [_btAgreed setTitle:NSLocalizedString(@"AcessarSantander", @"") forState:UIControlStateNormal];
}

-(void) setTitle:(NSString*)title instructions:(NSString*)instructions summaryInstructions:(NSString*)summaryInstructions linecode:(NSString*) linecode completeInstructions:(NSString*) completeInstructions{
    [_lblTitle setText:title];
    [_lblInstructions1 setText:instructions];
    [_lblPaymentInstructions setText:summaryInstructions];
    [_lblDateAndPayment setText:linecode];
    if(![completeInstructions isEqualToString:@""]){
        [_btTerms setHidden:NO];
    }else{
        [_btTerms setHidden:YES];
    }
}
@end
