//
//  HomeView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 05/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "HomeView.h"
#import <FontAwesome/NSString+FontAwesome.h>

@interface HomeView (){
    UIActivityIndicatorView *activity;
    HomeViewController *currentController;
    BOOL hide_assist;
    float finalHeightPayments;

}
@end
@implementation HomeView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView:(PolicyBeans*)beans controller:(HomeViewController*)controller{

//    [_scrollView setFrame:self.frame];
    currentController = controller;
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_widthView setConstant:CGRectGetMaxX(self.frame) - 16 ];
    
    finalHeightPayments = 100;
    
    NSMutableAttributedString* string = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Apolice",@"")];
    [string addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, string.length)];
    [string addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, string.length)];//TextColor
    [string addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0, string.length)];//Underline color
    [string addAttribute:NSUnderlineColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, string.length)];//TextColor
    _lblTitlePolicy.attributedText = string;
    
//    _lblTitlePolicy.text = NSLocalizedString(@"Apolice",@"");
//    [_lblTitlePolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
//    [_lblTitlePolicy setTextColor:[BaseView getColor:@"AzulEscuro"]];
    
    
    
    
//    [_lblPolicyNumber setFont:[BaseView getDefatulFont:Small bold:NO]];
//    [_lblPolicyNumber setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    [_btDetails setTitle:NSLocalizedString(@"DetalhesApolice", @"") forState:UIControlStateNormal];
    [_btDetails setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btDetails setBorderWidth:1];
    [_btDetails setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btDetails setBorderRound:7];
    
    [_lblInformation setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblInformation setTextColor:[BaseView getColor:@"TextoDestaque"]];
    [_lblInformation setText:NSLocalizedString(@"MaisInfoSeguro", @"")];

    [_lblTypePoliy setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    [_lblTypePoliy setTextColor:[BaseView getColor:@"AzulClaro"]];
    [_lblPolicyDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblPolicyDescription setTextColor:[BaseView getColor:@"CinzaEscuro"]];

    
    bool hideWorkShop = false;
    if([Config isAliroProject]){
        _posXButtonAssist.constant = -_userInfoView.frame.size.width * (1.0f - 0.30);
        _posXButtonAutoWork.constant = -_userInfoView.frame.size.width * (1.0f - 0.70);
    }else{
        [_lblTypePoliy setTextColor:[BaseView getColor:@"AzulEscuro"]];
        if([beans.insurance isAutoPolicy]){
            _posXButtonAssist.constant = -_userInfoView.frame.size.width * (1.0f - 0.20);
            _posXButtonAutoWork.constant = -_userInfoView.frame.size.width * (1.0f - 0.50);
            _posXButtonClub.constant = -_userInfoView.frame.size.width * (1.0f - 0.80);
            hide_assist = false;
        }else{
            
            if(beans.insurance.allowPHS){
                hide_assist = false;
                _posXButtonAssist.constant = -_userInfoView.frame.size.width * (1.0f - 0.30);
                _posXButtonClub.constant = -_userInfoView.frame.size.width * (1.0f - 0.70);
//                [_btAssist setImage:[UIImage imageNamed:@"icon_oval_home.png"] forState:UIControlStateNormal];
                
            }else{
                hide_assist = true;
                _posXButtonClub.constant = -_userInfoView.frame.size.width * (1.0f - 0.50);
            }
            hideWorkShop = true;
        }
        
    }
    
    [_btAssist setHidden:hide_assist];
    [_btAutoWorkShop setHidden:hideWorkShop];
    
    _iconClaim.image = [_iconClaim.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_iconClaim setTintColor:[BaseView getColor:@"CinzaEscuro"]];
    [_titleClaim setFont:[BaseView getDefatulFont:Micro bold:YES]];
    
    NSMutableAttributedString *titleClaim = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"StatusSinistro",@"")];
    [titleClaim addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [titleClaim length])];
    [titleClaim addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:[NSLocalizedString(@"StatusSinistro",@"") rangeOfString:NSLocalizedString(@"BoldSinistro",@"")]];
    [_titleClaim setAttributedText:titleClaim];
    
    [_btMorePolices setHidden:YES];
    [_btMorePolices setTitle:NSLocalizedString(@"MaisApolices", @"") forState:UIControlStateNormal];
    [_btMorePolices setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btMorePolices setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btMorePolices setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    if(![Config isAliroProject]){
        [_btMorePolices setBorderColor:[BaseView getColor:@"Verde"]];
        [_btMorePolices setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btDetails setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btDetails setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        
    }
    
    
    [BaseView addDropShadow:_viewClaim];
    [BaseView addDropShadow:_viewPolicy];
    [BaseView addDropShadow:_viewParcels];
    
    
    

    NSMutableAttributedString *titlePayments = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TitlePaymentsHome",@"")];
    [titlePayments addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Large bold:NO] range:NSMakeRange(0, [titleClaim length])];
    [titlePayments addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Large bold:YES] range:[NSLocalizedString(@"TitlePaymentsHome",@"") rangeOfString:NSLocalizedString(@"BoldTitlePaymentsHome",@"")]];
    [_titlePaymentView setNumberOfLines:2];
    [_titlePaymentView setAttributedText:titlePayments];
    [_btExpand setBackgroundColor:[UIColor whiteColor]];
    
    NSString *iconDown = [NSString fontAwesomeIconStringForEnum:FAAngleUp];
    NSString *iconUp = [NSString fontAwesomeIconStringForEnum:FAAngleDown];

    [_btExpand setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"BtExpand", @""), iconUp] forState:UIControlStateNormal];
    [_btExpand setTitle:[NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"BtExpandSelected", @""),iconDown] forState:UIControlStateSelected];
    [_btExpand.titleLabel setFont:[UIFont fontWithName:kFontAwesomeFamilyName size:Small]];
    
    [_btExpand setTitleColor:[BaseView getColor:@"CinzaEscuro"] forState:UIControlStateNormal];
    [_btExpand setTitleColor:[BaseView getColor:@"CinzaEscuro"] forState:UIControlStateSelected];
    
    
    
    if(beans == nil){
        
        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity setCenter:self.center];
        [activity startAnimating];
        [self addSubview:activity];
        [_scrollView setHidden:YES];
        return;
    }
    
    
    NSMutableAttributedString* stringPolicy = [[NSMutableAttributedString alloc] initWithString:beans.insurance.policy];
    [stringPolicy addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, stringPolicy.length)];
    [stringPolicy addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, stringPolicy.length)];//TextColor
    [stringPolicy addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInt:1] range:NSMakeRange(0, stringPolicy.length)];//Underline color
    [stringPolicy addAttribute:NSUnderlineColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, stringPolicy.length)];//TextColor
    _lblPolicyNumber.attributedText = stringPolicy;
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(labelTap)];
    [tapGesture setNumberOfTouchesRequired:1];
    [tapGesture setCancelsTouchesInView:NO];
    
    UITapGestureRecognizer *tapGesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(labelTap)];
    [tapGesture2 setNumberOfTouchesRequired:1];
    [tapGesture2 setCancelsTouchesInView:NO];
    
    [_lblPolicyNumber addGestureRecognizer:tapGesture];
    [_lblTitlePolicy addGestureRecognizer:tapGesture2];
    _lblTitlePolicy.userInteractionEnabled = YES;
    _lblPolicyNumber.userInteractionEnabled = YES;
    
    _lblTypePoliy.text = beans.insurance.branchName;
    [_iconTypePolicy setImage:[UIImage imageNamed:beans.insurance.branchImageName]];
    _lblPolicyDescription.text = [NSString stringWithFormat:@"%@", ((ItemInsurance *)[beans.insurance.itens objectAtIndex:0]).desc];
    _lblPolicyDescription.numberOfLines = 3;
    _lblPolicyDescription.adjustsFontSizeToFitWidth = true;
    
    //Fix label position and text
    CGSize size = [_lblPolicyDescription sizeThatFits:CGSizeMake(_lblPolicyDescription.frame.size.width, CGFLOAT_MAX)];
    CGRect frame = _lblPolicyDescription.frame;
    frame.size.height = size.height;
    
    UILabel *lblDescriptionNew = [[UILabel alloc] initWithFrame:frame];
    [lblDescriptionNew setText:_lblPolicyDescription.text];
    [lblDescriptionNew setFont:_lblPolicyDescription.font];
    [lblDescriptionNew setNumberOfLines:_lblPolicyDescription.numberOfLines];
    [lblDescriptionNew setAdjustsFontSizeToFitWidth:_lblPolicyDescription.adjustsFontSizeToFitWidth];
    [lblDescriptionNew setTextColor:_lblPolicyDescription.textColor];
    [_viewPolicy addSubview:lblDescriptionNew];
    [_lblPolicyDescription setHidden:YES];
    
//    _lblPolicyNumber.text = beans.insurance.policy;
    
    
    
//    [self displayPaymentInformation:beans];
    
    
    
    [_btInstallments setTitle:NSLocalizedString(@"VisualizarParcelas", @"") forState:UIControlStateNormal];
    [_btInstallments setBorderWidth:1];
    [_btInstallments setBorderColor:[BaseView getColor:@"AzulEscuro"]];
    [_btInstallments setBorderRound:7];
    [_btInstallments setBackgroundColor:[BaseView getColor:@"Branco"]];
    [_btInstallments.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btInstallments setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
    

    
    [_durationPolicy setBackgroundColor:[UIColor whiteColor]];
    
    [_durationPolicy setOverArcPercent:(((float)beans.insurance.daysRemaining * 1.0f)/ (float) beans.insurance.totalDuration) color:[BaseView getColor:@"AzulClaro"]];
    [_durationPolicy setNumDays:[NSString stringWithFormat:@"%d",beans.insurance.daysRemaining]];
    [_durationPolicy setTitle:NSLocalizedString(@"Vigencia",@"")];
    [_durationPolicy setBackgroundColor:[UIColor clearColor]];
    [_durationPolicy setNeedsDisplay];
    
    
    [_IPVA setBackgroundColor:[UIColor whiteColor]];
    [_IPVA setOverArcPercent:((float)beans.insurance.ipvaRemaining/365.0f) color:[BaseView getColor:@"Laranja"]];
    [_IPVA setNumDays:[NSString stringWithFormat:@"%d",beans.insurance.ipvaRemaining]];
     [_IPVA setBackgroundColor:[UIColor clearColor]];
    [_IPVA setTitle:NSLocalizedString(@"IPVA",@"")];
    [_IPVA setNeedsDisplay];
    
    [_licensing setBackgroundColor:[UIColor whiteColor]];
    [_licensing setOverArcPercent:((float)beans.insurance.licensingRemaining/365.0f) color:[BaseView getColor:@"Verde"]];
    [_licensing setNumDays:[NSString stringWithFormat:@"%d",beans.insurance.licensingRemaining]];
    [_licensing setTitle:NSLocalizedString(@"Licenciamento",@"")];
      [_licensing setBackgroundColor:[UIColor clearColor]];
    [_licensing setNeedsDisplay];
    
//    if(![beans isAutoPolicy]){
        [_licensing setHidden:YES];
        [_IPVA setHidden:YES];
//    }
    
    
    [_scrollView setHidden:NO];
    
    [activity stopAnimating];
    [activity setHidden:YES];
    [_loadingPayments setHidden:YES];
    [_loadingPayments stopAnimating];
    
    ItemInsurance *item = [beans.insurance.itens objectAtIndex:0];
    if(item.claim.claimType <= 0){
        [self hideClaim];

    }else{
        
        NSMutableAttributedString *statusString = [[NSMutableAttributedString alloc] initWithString:item.claim.statusClaim];
        [statusString addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Large bold:NO] range:NSMakeRange(0, statusString.length)];
        [_imgStatusClaim setImage:[UIImage imageNamed:[NSString stringWithFormat:@"status_%d.png",[item.claim getStatusClaimCode]]]];
        switch ([item.claim getStatusClaimCode]) {
            case 10:
            case 40:
            case 100:
                [statusString addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, statusString.length)];
                if(![Config isAliroProject]){
                    [statusString addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, statusString.length)];
                }
                
                break;
                
            default:
                [statusString addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Laranja"] range:NSMakeRange(0, statusString.length)];
                break;
        }
        
        [_statusClaim setAttributedText:statusString];
    }

}

-(void)labelTap{
    [currentController showPolicyDetail:nil];
    
}

-(void) displayPaymentInformation:(PolicyBeans*)beans{

    float posYView = 0;
    int count = 0;
    
    for (UIView *_v in _containerPayments.subviews) {
        [_v removeFromSuperview];
    }
    
    
    for (PaymentBeans *payment in beans.payments) {
  
        
        float posY = 0;
        float heigth = 20;
        float margin = 10;
        
     
        
        UIView *paymentView = [[UIView alloc] initWithFrame:CGRectMake(30, posYView, _containerPayments.frame.size.width-30, 150)];
        
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
        [viewDivisor setBackgroundColor:[UIColor grayColor]];
        [paymentView addSubview:viewDivisor];
        
        
        
        UIImageView *_imgStatus = [[UIImageView alloc] initWithFrame:CGRectMake((paymentView.frame.size.width)/2 + margin, 0 , widthImages, widthImages)];
        [paymentView addSubview:_imgStatus];
        


        UIView *viewDivisor2 = [[UIView alloc] initWithFrame:CGRectMake(((paymentView.frame.size.width)/2) + (paymentView.frame.size.width/4), 0 , 1, widthImages)];
        [viewDivisor2 setBackgroundColor:[UIColor grayColor]];
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
        if([Config isAliroProject]){
            [_lblPaymentDate setTextColor:[BaseView getColor:@"AzulClaro"]];
        }else{
            [_lblPaymentDate setTextColor:[BaseView getColor:@"AzulEscuro"]];
        }
        
        [_lblPaymentDate setAdjustsFontSizeToFitWidth:YES];
        [_lblPaymentDate setMinimumScaleFactor:0.5f];
        
        [_lblPaymentValue setFont:[BaseView getDefatulFont:Small bold:YES]];
        [_lblPaymentValue setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        
        
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
            [_btPay addTarget:currentController action:@selector(openExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:count];
        }else if(payment.showComponent == 2  || payment.showComponent == 5 || payment.showComponent == 6){
            [_btPay setImage:[UIImage imageNamed:@"prorrogar"] forState:UIControlStateNormal];
            [_btPay.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_btPay addTarget:currentController action:@selector(openExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:count];
        }else if(payment.showComponent == 3){
            [_btPay setImage:[UIImage imageNamed:@"payment_barcode"] forState:UIControlStateNormal];
            [_btPay.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_btPay addTarget:currentController action:@selector(openExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:count];
        }else  if(payment.showComponent == 2){
            [_btPay setImage:[UIImage imageNamed:@"prorrogar"] forState:UIControlStateNormal];
            [_btPay.imageView setContentMode:UIViewContentModeScaleAspectFit];
            [_btPay addTarget:currentController action:@selector(openExtendPayment:) forControlEvents:UIControlEventTouchUpInside];
            [_btPay setTag:count];
        }else{
            [_btPay setHidden:YES];
        }

        
     
        
        
        
        if(payment.nextDueDate!= nil && ![payment.nextDueDate isEqualToString:@""] && payment.nextValue > 0.0f){
            NSString *myString = [[payment.nextDueDate componentsSeparatedByString:@"T"] objectAtIndex:0];
            NSString *datePayment = [[[[myString componentsSeparatedByString:@"-"] reverseObjectEnumerator] allObjects] componentsJoinedByString:@"/"];
            NSString *valuePayment = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:payment.nextValue]];
            NSString *fullPhrase = [NSString stringWithFormat:NSLocalizedString(@"PagamentoFrase", @""),datePayment , valuePayment];
            
            NSMutableAttributedString *paymentPhrase = [[NSMutableAttributedString alloc] initWithString:fullPhrase];
            [paymentPhrase addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [fullPhrase length])];
            
            [paymentPhrase addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [fullPhrase length])];
            
            NSRange range = [fullPhrase rangeOfString:datePayment];
            [paymentPhrase addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:range];
            
            [paymentPhrase addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:[fullPhrase rangeOfString:valuePayment]];
            
            _lblPaymentDescription.adjustsFontSizeToFitWidth = true;
            [_lblPaymentDescription setAttributedText:paymentPhrase];
            _lblPaymentDescription.lineBreakMode = NSLineBreakByTruncatingTail;
            [_lblPaymentDescription setHidden:NO];
        }else{
            if(payment.status == 1){
                NSMutableAttributedString *paymentPhrase = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"AllPaymentsDone", @"")];
                [paymentPhrase addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [paymentPhrase length])];
                
                [paymentPhrase addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [paymentPhrase length])];
                _lblPaymentDescription.adjustsFontSizeToFitWidth = true;
                [_lblPaymentDescription setAttributedText:paymentPhrase];
                [_lblPaymentDescription setHidden:NO];
            }else{
                [_lblPaymentDescription setHidden:YES];
                posY -= (margin+heigth);
            }
        }
        
        
        UIButton *_btParcels = [[UIButton alloc] initWithFrame:CGRectMake(0, posY, 80, heigth)];
        
        NSMutableAttributedString *detailText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"VerDetalhes", @"")];
        [detailText addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, [NSLocalizedString(@"VerDetalhes", @"") length])];
        [detailText addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"VerDetalhes", @"") length])];
        [detailText addAttribute:NSUnderlineColorAttributeName
                           value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, [NSLocalizedString(@"VerDetalhes", @"") length])];
        [detailText addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"VerDetalhes", @"") length])];
        
        [_btParcels setAttributedTitle:detailText forState:UIControlStateNormal];
        [_btParcels addTarget:currentController action:@selector(openParcels:) forControlEvents:UIControlEventTouchUpInside];
        [_btParcels setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_btParcels setTag:count];
        [paymentView addSubview:_btParcels];
        
        posY += margin+heigth;
        posY += margin+heigth;
        
        posYView += CGRectGetHeight(paymentView.frame);
        
        
        
        [_containerPayments addSubview:paymentView];
        
        
        finalHeightPayments = 80 + posYView;
        
//        [_heightContainer setConstant: 80 + posYView];
        
        count++;
    }
  
}


-(void)expandPayments:(BOOL) expanded loading:(BOOL)loading{
    
    [_btExpand setSelected:expanded];
    if(expanded){
        //            [_heightContainer setConstant: finalHeightPayments];
        [_loadingPayments setHidden:!loading];
        if(loading){
            _heightContainer.constant = 120;
            [_loadingPayments startAnimating];
        }else{
            _heightContainer.constant = finalHeightPayments;
        }
    }else{
        //            [_heightContainer setConstant: 80];
        _heightContainer.constant = 80;
    }
    
    [self setNeedsLayout];

    [UIView animateWithDuration:.5f animations:^{
        [self layoutIfNeeded];
    }];
    
    
    
}

-(void) hideScrollView{
    [_scrollView setHidden:YES];
}

-(void) loadViewAfterAppeared{

       
    if([Config isAliroProject]){
        [_btClub setHidden:YES];;
    
        [_btAssist displayButtonWithTitle:NSLocalizedString(@"SinistroAssitencia",@"") titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
        
        
        
        [_btAutoWorkShop displayButtonWithTitle:NSLocalizedString(@"OficinasReferenciadas",@"") titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];

    
//    }else{
//        [_btClub displayButtonWithTitle:NSLocalizedString(@"ClubeVantagens",@"") titleColor:[BaseView getColor:@"AzulEscuro"] titleFont:[BaseView getDefatulFont:Nano bold:NO]];
    }
     
    
    
    [_userInfoView loadViewHome];

    
    [self updateConstraintsIfNeeded];
    
    
}

-(void)hideVision{
    [_visionButton setHidden:YES];
}
-(void)showVision{
    [_visionButton setHidden:NO];
}

-(void)hideClaim{
    [_viewClaim setHidden:YES];
    [_spaceBetweenTimers setConstant:40];
    [_bottomSpace setConstant:20];
}

-(void) showMorePolicesButton{
    [_btMorePolices setHidden:NO];
    [_bottomSpace setConstant:60];
}

-(void) stopLoading{
    [activity stopAnimating];
    [activity setHidden:YES];
}

@end
