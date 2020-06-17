//
//  ExtendParcelView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 27/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ExtendParcelView.h"
@interface ExtendParcelView(){
    NSString *currentDate;
    NSString *currentValue;
    
    
}
@end

@implementation ExtendParcelView

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
    
    [_lblInstructions1 setText:NSLocalizedString(@"ProrrogarDesc1", @"")];
    [_lblInstructions1 setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblInstructions1 setTextColor:[BaseView getColor:@"CinzaClaro"]];
    
    [_lblPaymentInstructions setText:NSLocalizedString(@"ProrrogarDesc2", @"")];
    [_lblPaymentInstructions setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblPaymentInstructions setTextColor:[BaseView getColor:@"CinzaClaro"]];
    
    [_lblTerms setText:NSLocalizedString(@"TermosProrrogar", @"")];
    [_btAgreed setTitle:NSLocalizedString(@"BtConcordar", @"")  forState:UIControlStateNormal];
    [_swAgreed setOnTintColor:[BaseView getColor:@"CorBotoes"]];
    [_swAgreed addTarget:self action:@selector(changeAgreeButton:) forControlEvents:UIControlEventValueChanged];
    
    [_btAgreed setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btAgreed setBorderWidth:1];
    [_btAgreed setBorderRound:7];
    [_btAgreed setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btAgreed.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btAgreed setTitle:NSLocalizedString(@"BtConcordar", @"") forState:UIControlStateNormal];
    [_btAgreed setHidden:YES];
    [BaseView addDropShadow:_boxView];
    
    
    
    [_lblTitleSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
    [_lblTitleSuccess setTextColor:[BaseView getColor:@"Verde"]];
    [_lblTitleSuccess setText:NSLocalizedString(@"ParcelProrrogada", @"")];
    
    if ([ [ UIScreen mainScreen ] bounds ].size.height >= 568){
        [_lblInstructionsSuccess setFont:[BaseView getDefatulFont:Small bold:NO]];
    }else{
        [_lblInstructionsSuccess setFont:[BaseView getDefatulFont:Micro bold:NO]];
    }
    
    [_lblInstructionsSuccess setTextColor:[BaseView getColor:@"Branco"]];
    
    
    NSMutableAttributedString * btTermsTitle  = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"BtTermosAcordo", @"")];
    [btTermsTitle addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, btTermsTitle.length)];
    [btTermsTitle addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, btTermsTitle.length)];
    [btTermsTitle addAttribute:NSUnderlineColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, btTermsTitle.length)];
    [btTermsTitle addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, btTermsTitle.length)];
    [_btTerms setAttributedTitle:btTermsTitle forState:UIControlStateNormal];
    
    [_btOpenPDF setTitle:NSLocalizedString(@"CopiarBoleto", @"") forState:UIControlStateNormal];
    [_btOpenPDF.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btOk setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    [_btOk.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    
    if(![Config isAliroProject]){
        [_btOk setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btOk setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btOk setBorderColor:[BaseView getColor:@"Verde"]];
        [_btOk customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    
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
    [_lblTerms setHidden:YES];
    [_btAgreed setHidden:YES];
    [_swAgreed setHidden:YES];
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
    [_lblTerms setHidden:NO];
    [_swAgreed setHidden:NO];
    [_line1 setHidden:NO];
    [_line2 setHidden:NO];
    if([_swAgreed isOn]){
        [_btAgreed setHidden:NO];
    }else{
        [_btAgreed setHidden:YES];
    }
}
-(void) hidePopUp{
    [self stopLoading];
    [_boxView setHidden:YES];
}

-(void) showPopUpSuccessfull:(NSString*) barCode{
    [_boxView setHidden:YES];
    NSMutableAttributedString *attributtedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:NSLocalizedString(@"ParcelProrrogadaInstrucoes", @""),currentDate,currentValue,barCode]];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init] ;
    [paragraphStyle setAlignment:NSTextAlignmentCenter];
    [attributtedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributtedString length])];
    [attributtedString addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0, [attributtedString length])];
    [_lblInstructionsSuccess setAttributedText: attributtedString];
    [_popUpSuccess setHidden:NO];

}

-(IBAction)changeAgreeButton:(id)sender{
    if([_swAgreed isOn]){
        [_btAgreed setHidden:NO];
    }else{
        [_btAgreed setHidden:YES];
    }
}
-(void) setDate:(NSString*)date setValue:(NSString*)value{
    
    currentDate = date;
    currentValue = value;
    
    NSMutableAttributedString *dateString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"NovaData",@"")];
    [dateString addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, dateString.length)];
    [dateString addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, dateString.length)];
    
    NSMutableAttributedString *dateValue = [[NSMutableAttributedString alloc] initWithString:date];
    [dateValue addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, date.length)];
    [dateValue addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, date.length)];
    
    NSMutableAttributedString *valueString = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Valor",@"")];
    [valueString addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, valueString.length)];
    [valueString addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, valueString.length)];

    NSMutableAttributedString *valueFinal = [[NSMutableAttributedString alloc] initWithString:value];
    [valueFinal addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, value.length)];
    [valueFinal addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, value.length)];
    
    NSMutableAttributedString *finalString = [[NSMutableAttributedString alloc] init];
    [finalString appendAttributedString:dateString];
    [finalString appendAttributedString:dateValue];
    [finalString appendAttributedString:valueString];
    [finalString appendAttributedString:valueFinal];
    
    [_lblDateAndPayment setAttributedText:finalString];

}

@end
