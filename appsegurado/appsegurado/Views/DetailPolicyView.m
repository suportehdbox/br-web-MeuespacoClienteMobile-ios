//
//  DetailPolicyView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 17/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "DetailPolicyView.h"


@interface DetailPolicyView (){
    UIActivityIndicatorView *activity;
    BOOL showOldPolicy;
    DetailPolicyViewController *controller;
}
@end
@implementation DetailPolicyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView:(PolicyBeans *)policybeans controller:(DetailPolicyViewController*) cont{
    //    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(_btPrivacy.frame) + 10)];
    //    [_scrollView setFrame:self.frame];
    [_widthCard setConstant:CGRectGetMaxX(self.frame) - 30];
   
    //    [self updateConstraintsIfNeeded];
    //    CGRect windowRect = self.window.frame;
    //    if(windowRect.size.height <= 568){
    //        [_spaceBotToBts setConstant:10];
    //        [_spaceBtsToLogin setConstant:10];
    //    }
    
    
    InsuranceBeans *beans = policybeans.insurance;
    
    _lblTitlePolicy.text = NSLocalizedString(@"Apolice",@"");
    [_lblTitlePolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitlePolicy setTextColor:[BaseView getColor:@"AzulEscuro"]];
    _lblPolicyNumber.text = beans.policy;
    [_lblPolicyNumber setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblPolicyNumber setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    


//    NSCalendar *cal = [NSCalendar currentCalendar];
//    NSDate *nextPaymentDate = [cal dateByAddingUnit:NSCalendarUnitMonth value:1 toDate:dueDate options:0];
//    
//    [dateformat setDateFormat:@"dd/MM/YYYY"];
    
//    [_lblPaymentDescription setText:[NSString stringWithFormat:NSLocalizedString(@"PagamentoFrase", @""), [dateformat stringFromDate:nextPaymentDate], [numberFormatter stringFromNumber:[NSNumber numberWithFloat:beans.payment.amountPayable]]]];
    
    
    
    
    [_btCoverages setTitle:NSLocalizedString(@"COBERTURASSEGURO", @"") forState:UIControlStateNormal];
    [_btCoverages setBorderWidth:1];
    [_btCoverages setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btCoverages setBorderRound:7];
    [_btCoverages setBackgroundColor:[BaseView getColor:@"Branco"]];
    [_btCoverages.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btCoverages setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    
    [_bt2Policy setTitle:[NSLocalizedString(@"BaixarSegundaVia", @"") uppercaseString] forState:UIControlStateNormal];
    [_bt2Policy setBorderWidth:1];
    [_bt2Policy setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_bt2Policy setBorderRound:7];
    [_bt2Policy setBackgroundColor:[BaseView getColor:@"Branco"]];
    [_bt2Policy.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_bt2Policy setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
   

    if (![Config isAliroProject]) {
        [_btCoverages setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_btCoverages setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btCoverages customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
        [_bt2Policy setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_bt2Policy setBorderColor:[BaseView getColor:@"Verde"]];
        [_bt2Policy customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    
    
    if(![beans.insuranceCoverages isEqualToString:@""]){
        NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"SeguroCobreTitulo",@"")];
        [title addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, title.length)];
        [title addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, title.length)];
        
        NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:beans.insuranceCoverages];
        [desc addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, beans.insuranceCoverages.length)];
        [desc addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, desc.length)];
        
        [title appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n\n"]];
        [title appendAttributedString:desc];
        
        
        
        CGFloat width = _txtCoverages.frame.size.width; // whatever your desired width is
        CGRect rect = [title boundingRectWithSize:CGSizeMake(width, 10000) options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading context:nil];
        [_coverageSpace setConstant:(rect.size.height + 50)];
        [_txtCoverages setAttributedText:title];
        [_txtCoverages setScrollEnabled:NO];
        [_heightCard setConstant:575 + (rect.size.height + 20)];
    }else{
           [_heightCard setConstant:575];
        [_coverageSpace setConstant:-1];
    }
    
    
    _lblAgentName.text = beans.broker.desc;
    [_lblAgentName setFont:[BaseView getDefatulFont:Medium bold:NO]];
    [_lblAgentName setTextColor:[BaseView getColor:@"AzulClaro"]];
    [_btPhoneAgent setTitle:beans.broker.phone forState:UIControlStateNormal];
    [_btPhoneAgent.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btPhoneAgent.titleLabel setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_btMail setTitle:beans.broker.email forState:UIControlStateNormal];
    [_btMail.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btMail.titleLabel setTextColor:[BaseView getColor:@"CinzaEscuro"]];

    [_lblTalkAgent setText:NSLocalizedString(@"FaleCorretor",@"")];
    [_lblTalkAgent setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblTalkAgent setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
   
    

    [_durationPolicy setBackgroundColor:[UIColor whiteColor]];
    [_durationPolicy setOverArcPercent:(((float) beans.daysRemaining * 1.0f)/ (float) beans.totalDuration) color:[BaseView getColor:@"AzulClaro"]];
    [_durationPolicy setNumDays:[NSString stringWithFormat:@"%d",beans.daysRemaining]];
    [_durationPolicy setTitle:NSLocalizedString(@"Vigencia",@"")];
    [_durationPolicy setNeedsDisplay];
    
    
    [_IPVA setBackgroundColor:[UIColor whiteColor]];
    [_IPVA setOverArcPercent:((float)beans.ipvaRemaining/365.0f) color:[BaseView getColor:@"Laranja"]];
    [_IPVA setNumDays:[NSString stringWithFormat:@"%d",beans.ipvaRemaining]];
    [_IPVA setTitle:NSLocalizedString(@"IPVA",@"")];
    [_IPVA setNeedsDisplay];
    
    [_licensing setBackgroundColor:[UIColor whiteColor]];
    [_licensing setOverArcPercent:((float)beans.licensingRemaining/365.0f) color:[BaseView getColor:@"Verde"]];
    [_licensing setNumDays:[NSString stringWithFormat:@"%d",beans.licensingRemaining]];
    [_licensing setTitle:NSLocalizedString(@"Licenciamento",@"")];
    [_licensing setNeedsDisplay];
    
    [_showOldPolices setHidden:!showOldPolicy];
    [_showOldPolices setBorderWidth:1];
    [_showOldPolices setBorderRound:7];
    [_showOldPolices setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_showOldPolices setBackgroundColor:[BaseView getColor:@"Branco"]];
    [_showOldPolices.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_showOldPolices setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_showOldPolices setTitle:NSLocalizedString(@"ApolicesAntigas", @"") forState:UIControlStateNormal];
    
    if(![Config isAliroProject]){
        [_showOldPolices setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_showOldPolices setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_showOldPolices customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
    }
    
//    if(![beans isAutoPolicy]){
        [_licensing setHidden:YES];
        [_IPVA setHidden:YES];
//    }
    
    [self displayCoveragesInformation:beans];
    
    [self displayPaymentInformation:policybeans controller:cont];
    
}


-(void) displayCoveragesInformation:(InsuranceBeans*)beans{
    float posY = 0;
    float widthImage =  CGRectGetWidth(_iconPolicy.frame);
    float margin = 5;
    
    NSArray *viewsToRemove = [_containerCoverage subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }

    
    for (int i = 0; i < [beans.itens count]; i++) {
        ItemInsurance *item = [beans.itens objectAtIndex:i];
        
        UIImageView *_iconTypePolicy = [[UIImageView alloc] initWithFrame:CGRectMake(1, posY, widthImage-2, widthImage-2)];
        [_iconTypePolicy setImage:[UIImage imageNamed:beans.branchImageName]];
        [_iconTypePolicy setContentMode:UIViewContentModeScaleAspectFit];
        [_containerCoverage addSubview:_iconTypePolicy];
        
        UILabel *_lblTypePoliy = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconTypePolicy.frame) + (margin * 2), posY, (widthImage*2), widthImage)];
        _lblTypePoliy.text = beans.branchName;
        _lblTypePoliy.adjustsFontSizeToFitWidth = true;
        [_lblTypePoliy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_lblTypePoliy setTextColor:[BaseView getColor:@"AzulClaro"]];
        [_lblTypePoliy sizeToFit];
        if(![Config isAliroProject]){
            [_lblTypePoliy setTextColor:[BaseView getColor:@"AzulEscuro"]];
        }
        
        [_containerCoverage addSubview:_lblTypePoliy];
        
        
        UILabel *_lblPolicyDescription = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_lblTypePoliy.frame) + (margin*2), posY, (CGRectGetWidth(_containerCoverage.frame) -  CGRectGetMaxX(_lblTypePoliy.frame) - margin), (widthImage * 2.5f) )];
        _lblPolicyDescription.numberOfLines = 3;
        _lblPolicyDescription.adjustsFontSizeToFitWidth = true;
        _lblPolicyDescription.text = [NSString stringWithFormat:@"%@",item.desc];
        [_lblPolicyDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
        
        CGSize size = [_lblPolicyDescription sizeThatFits:CGSizeMake(_lblPolicyDescription.frame.size.width, CGFLOAT_MAX)];
        CGRect frame = _lblPolicyDescription.frame;
        frame.size.height = size.height;
        _lblPolicyDescription.frame = frame;
        
        
        
        
        [_lblPolicyDescription setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [_containerCoverage addSubview:_lblPolicyDescription];
        
        
        posY = CGRectGetMaxY(_lblPolicyDescription.frame);
        posY += margin;
    }
    [_heightCoverage setConstant:posY];
    
    [_heightCard setConstant:_heightCard.constant + _heightCoverage.constant];

}

-(void) displayPaymentInformation:(PolicyBeans*)beans controller:(DetailPolicyViewController*) cont{
    
    NSArray *viewsToRemove = [_containerPayments subviews];
    for (UIView *v in viewsToRemove) {
        [v removeFromSuperview];
    }
    [_heightContainer setConstant: 10];
    
    float posYView = 0;
    
    for (int i = 0; i < [beans.payments count]; i++) {
        
        PaymentBeans *payment = [beans.payments objectAtIndex:i];
        
        float posY = 0;
        float heigth = 20;
        float margin = 10;
        
        if(posYView > 0){
            posYView += (margin * 3);
        }
        
        UIView *paymentView = [[UIView alloc] initWithFrame:CGRectMake(margin, posYView, _containerPayments.frame.size.width-margin, 170)];
        
        UILabel *_lblPayment = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, (paymentView.frame.size.width)/2, heigth)];
        [paymentView addSubview:_lblPayment];
        posY += margin+heigth;
        
        
        UILabel *_lblPaymentDate = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, (paymentView.frame.size.width)/2, heigth)];
        [paymentView addSubview:_lblPaymentDate];
        posY += margin+heigth;
        
        UILabel *_lblPaymentValue = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, (paymentView.frame.size.width)/2, heigth)];
        [paymentView addSubview:_lblPaymentValue];
        posY += margin+heigth;
        
        UILabel *_lblPaymentDescription = [[UILabel alloc] initWithFrame:CGRectMake(0, posY, paymentView.frame.size.width, heigth)];
        [paymentView addSubview:_lblPaymentDescription];
        posY += margin+heigth;
        
        float widthImages = (paymentView.frame.size.width)/4 - (margin*2);
        
        
        UIView *viewDivisor = [[UIView alloc] initWithFrame:CGRectMake((paymentView.frame.size.width)/2, 0 , 1, widthImages)];
        [viewDivisor setBackgroundColor:[self backgroundColor]];
        [paymentView addSubview:viewDivisor];
        
        
        
        UIImageView *_imgStatus = [[UIImageView alloc] initWithFrame:CGRectMake((paymentView.frame.size.width)/2 + margin, 0 , widthImages, widthImages)];
        [paymentView addSubview:_imgStatus];
        
        
        
        UIView *viewDivisor2 = [[UIView alloc] initWithFrame:CGRectMake(((paymentView.frame.size.width)/2) + (paymentView.frame.size.width/4), 0 , 1, widthImages)];
        [viewDivisor2 setBackgroundColor:[self backgroundColor]];
        [paymentView addSubview:viewDivisor2];
        
        
        UIButton *_btPay = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetMaxX(viewDivisor2.frame) + margin, 0 , widthImages, widthImages)];
        [paymentView addSubview:_btPay];
        
        
        
        if(payment.amountOfInstallment == 1){
            [_lblPayment setText:NSLocalizedString(@"Pagamento",@"")];
        }else{
            [_lblPayment setText:[NSString stringWithFormat:NSLocalizedString(@"Parcelas",@""), payment.number, payment.amountOfInstallment]];
        }
        [_lblPayment setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_lblPayment setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        
        
        [_lblPaymentDate setFont:[BaseView getDefatulFont:Medium bold:YES]];
        [_lblPaymentDate setTextColor:[BaseView getColor:@"AzulClaro"]];
        [_lblPaymentDate setAdjustsFontSizeToFitWidth:YES];
        [_lblPaymentDate setMinimumScaleFactor:0.5f];
        
        [_lblPaymentValue setFont:[BaseView getDefatulFont:Small bold:YES]];
        [_lblPaymentValue setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        
        if([Config isAliroProject]){
            [_lblPaymentDate setTextColor:[BaseView getColor:@"AzulClaro"]];
        }else{
            [_lblPaymentDate setTextColor:[BaseView getColor:@"AzulEscuro"]];
        }
        
        
        NSDateFormatter *dateformat = [[NSDateFormatter alloc] init];
        [dateformat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss"];
        NSDate *dueDate = [dateformat dateFromString:payment.dueDate];
        [dateformat setTimeZone:[NSTimeZone localTimeZone]];
        [dateformat setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
        [dateformat setDateFormat:@"dd MMMM"];
        
        [_lblPaymentDate setText:[dateformat stringFromDate:dueDate]];
        
        
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
        [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];
        
        
        
        
        [_lblPaymentValue setText:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:payment.amountPayable]]];
        
        
        if(payment.status == 1){
            if(payment.nextDueDate != nil && ![payment.nextDueDate isEqualToString:@""] && payment.nextValue > 0.0f){
                [_imgStatus setImage:[UIImage imageNamed:@"payment_ok"]];
            }else{
                [_imgStatus setImage:[UIImage imageNamed:@"icon_oval_payment_finish"]];
            }
        }else if(payment.status == 2){
            [_imgStatus setImage:[UIImage imageNamed:@"payment_late"]];
        }else if(payment.status == 3){
            [_imgStatus setImage:[UIImage imageNamed:@"processamento"]];
        }else if(payment.status == 4){
            [_imgStatus setImage:[UIImage imageNamed:@"analise"]];
        }else{
            [_imgStatus setImage:[UIImage imageNamed:@"payment_waiting"]];
        }
        
        [_imgStatus setContentMode:UIViewContentModeScaleAspectFit];

        
        if(payment.showComponent == 1 || payment.showComponent == 4 || payment.showComponent == 7){
            [_btPay setImage:[UIImage imageNamed:@"payment_barcode"] forState:UIControlStateNormal];
            [_btPay.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_btPay addTarget:controller action:@selector(btExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:i];
        }else if(payment.showComponent == 2  || payment.showComponent == 5 || payment.showComponent == 6){
            [_btPay setImage:[UIImage imageNamed:@"prorrogar"] forState:UIControlStateNormal];
            [_btPay.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_btPay addTarget:controller action:@selector(btExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:i];
        }else if(payment.showComponent == 3){
            [_btPay setImage:[UIImage imageNamed:@"payment_barcode"] forState:UIControlStateNormal];
            [_btPay.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_btPay addTarget:controller action:@selector(btExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:i];
        }else{
            [_btPay setHidden:YES];
        }
        
        

        
        if(payment.nextDueDate!= nil && ![payment.nextDueDate isEqualToString:@""] && payment.nextValue > 0.0f){
            
            
            NSString *myString = [[payment.nextDueDate componentsSeparatedByString:@"T"] objectAtIndex:0];
            NSString *datePayment = [[[[myString componentsSeparatedByString:@"-"] reverseObjectEnumerator] allObjects] componentsJoinedByString:@"/"];
            
            NSString *valuePayment = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:payment.nextValue]];
            NSString *fullPhrase = [NSString stringWithFormat:NSLocalizedString(@"PagamentoFrase", @""),datePayment , valuePayment];
            
            NSMutableAttributedString *payment = [[NSMutableAttributedString alloc] initWithString:fullPhrase];
            [payment addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [fullPhrase length])];
            
            [payment addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [fullPhrase length])];
            
            NSRange range = [fullPhrase rangeOfString:datePayment];
            [payment addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:range];
            
            [payment addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:[fullPhrase rangeOfString:valuePayment]];
            
            _lblPaymentDescription.adjustsFontSizeToFitWidth = true;
            [_lblPaymentDescription setAttributedText:payment];
            _lblPaymentDescription.lineBreakMode = NSLineBreakByTruncatingTail;
            [_lblPaymentDescription setHidden:NO];
        }else{
             if(payment.status == 1){
                 NSMutableAttributedString *payment = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"AllPaymentsDone", @"")];
                 [payment addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [payment length])];
                 
                 [payment addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [payment length])];
                 _lblPaymentDescription.adjustsFontSizeToFitWidth = true;
                 [_lblPaymentDescription setAttributedText:payment];
                 [_lblPaymentDescription setHidden:NO];
             }else{
                [_lblPaymentDescription setHidden:YES];
             }
        }
        
        CustomButton *_btInstallments = [[CustomButton alloc] initWithFrame:CGRectMake((paymentView.frame.size.width - _btCoverages.frame.size.width)/2, posY, _btCoverages.frame.size.width, _btCoverages.frame.size.height)];
        [_btInstallments setTitle:NSLocalizedString(@"VisualizarParcelas", @"") forState:UIControlStateNormal];
        [_btInstallments setBorderWidth:1];
        [_btInstallments setBorderColor:[BaseView getColor:@"CorBotoes"]];
        [_btInstallments setBorderRound:7];
        [_btInstallments setBackgroundColor:[BaseView getColor:@"Branco"]];
        [_btInstallments setTag:i];
        [_btInstallments.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_btInstallments setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btInstallments addTarget:cont action:@selector(btShowParcels:) forControlEvents:UIControlEventTouchUpInside];
        
        if(![Config isAliroProject]){
            [_btInstallments setBackgroundColor:[BaseView getColor:@"Amarelo"]];
            [_btInstallments setBorderColor:[BaseView getColor:@"Amarelo"]];
            [_btInstallments customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
        }
        
        [paymentView addSubview:_btInstallments];
        
        
        posY += _btCoverages.frame.size.height + (margin * 2);
        
        UIView *viewDivisor3 = [[UIView alloc] initWithFrame:CGRectMake(0, posY, _btCoverages.frame.size.width, 1)];
        [viewDivisor3 setBackgroundColor:[self backgroundColor]];
        [paymentView addSubview:viewDivisor3];
        
        
        posYView += posY + 1;
        
        [_containerPayments addSubview:paymentView];
        
    }
    [_heightContainer setConstant: _heightContainer.constant + posYView];
    
    [_heightCard setConstant:_heightCard.constant + _heightContainer.constant];
    
    
}
-(void) showLoading{
    if(activity == nil){
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity setCenter:self.center];
        [self addSubview:activity];
    }
    [activity startAnimating];
    [activity setHidden:NO];
    [_scrollView setHidden:YES];
}

-(void) stopLoading{
    [_scrollView setHidden:NO];
    [activity stopAnimating];
    [activity setHidden:YES];
}


-(void) showButtonOldPolices{
    showOldPolicy = YES;
    [_showOldPolices setHidden:!showOldPolicy];
    [_marginBotton setConstant:20];
}

-(void)hideVision{
    [_visionContainer setHidden:YES];
}
-(void)showVision{
    [_visionContainer setHidden:NO];
}
@end
