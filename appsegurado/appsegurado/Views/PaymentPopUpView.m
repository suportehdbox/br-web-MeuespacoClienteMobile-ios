//
//  PaymentPopUpView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 21/05/2018.
//  Copyright © 2018 Liberty Seguros. All rights reserved.
//

#import "PaymentPopUpView.h"
#import "PaymentOpt.h"

@interface PaymentPopUpView () {
    PaymentOpt currentComponent;
}
@end
@implementation PaymentPopUpView


/*
 * // Only override drawRect: if you perform custom drawing.
 * // An empty implementation adversely affects performance during animation.
 * - (void)drawRect:(CGRect)rect {
 *  // Drawing code
 * }
 */

- (void) loadView: (PaymentOpt)component {
    currentComponent = component;
    [self startLoading];

    [_lblTitlePayments setText:NSLocalizedString(@"TituloPagarParcela", @"")];
    [_lblTitlePayments setFont:[BaseView getDefatulFont:Medium bold:NO]];
//    [_lblTitlePayments setNumberOfLines:2];
    [_lblTitlePayments setTextColor:[BaseView getColor:@"AzulEscuro"]];

    [_btPaymentOpt1 setTitle:[NSLocalizedString(@"Pagar", @"") uppercaseString] forState:UIControlStateNormal];
    [_btPaymentOpt1.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btPaymentOpt1 setBorderWidth:1];
    [_btPaymentOpt1 setBorderRound:15.0f];
    [_btPaymentOpt1 setBorderColor:[BaseView getColor:@"AzulEscuro"]];
    [_btPaymentOpt1 setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];

    [_btPaymentOpt2 setTitle:[NSLocalizedString(@"Pagar", @"") uppercaseString] forState:UIControlStateNormal];
    [_btPaymentOpt2.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btPaymentOpt2.titleLabel setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_btPaymentOpt2 setBorderWidth:1];
    [_btPaymentOpt2 setBorderRound:15.0f];
    [_btPaymentOpt2 setBorderColor:[BaseView getColor:@"AzulEscuro"]];
    [_btPaymentOpt2 setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];


    if (![Config isAliroProject]) {
        [_btPaymentOpt1 setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btPaymentOpt1 setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btPaymentOpt1 setBorderColor:[BaseView getColor:@"Verde"]];
        [_btPaymentOpt1 customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];

        [_btPaymentOpt2 setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btPaymentOpt2 setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btPaymentOpt2 setBorderColor:[BaseView getColor:@"Verde"]];
        [_btPaymentOpt2 customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }

    [_lblPaymentOpt1 setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblPaymentOpt1 setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblPaymentOpt2 setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblPaymentOpt2 setTextColor:[BaseView getColor:@"CinzaEscuro"]];

    switch (component) {
        case PaymentOptTicket:
            // Ticket = 1 à Código de barras
            [_lblPaymentOpt1 setText:NSLocalizedString(@"SegundaViaBoleto", @"")];
            [_viewPayment2 removeFromSuperview];
            [_viewDivisor setHidden:YES];
            break;
        case PaymentOptReprogramming:
            // Reprogramming = 2 à Reprograma
            [_lblPaymentOpt1 setText:NSLocalizedString(@"ProrrogarParcela", @"")];
            [_viewPayment2 removeFromSuperview];
            [_viewDivisor setHidden:YES];
            break;
        case PaymentOptOnline:
            //  OnlinePayment = 3 à Pagamento online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"PagamentoOnline", @"")];
            [_viewPayment2 removeFromSuperview];
            [_viewDivisor setHidden:YES];
            break;
        case PaymentOptTicketAndOnline:
            // TicketAndOnlinePayment = 4 à Código de barras e Pagamento online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"SegundaViaBoleto", @"")];
            [_lblPaymentOpt2 setText:NSLocalizedString(@"PagamentoOnline", @"")];
            break;
        case PaymentOptReprogrammingAndOnline:
            // ReprogrammingAndOnlinePayment = 5 à Reprograma e Pagamento online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"ProrrogarParcela", @"")];
            [_lblPaymentOpt2 setText:NSLocalizedString(@"PagamentoOnline", @"")];
            break;
        case PaymentOptReprogrammingAndOnlineStatus:
            // ReprogrammingAndOnlineStatus = 6  à Reprograma e consulta pgt. online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"ProrrogarParcela", @"")];
            [_lblPaymentOpt2 setText:NSLocalizedString(@"ConsultarPagamento", @"")];
            [_btPaymentOpt2 setTitle:NSLocalizedString(@"Consultar", @"") forState:UIControlStateNormal];
            break;
        case PaymentOptTicketAndOnlineStatus:
            // TicketAndOnlineStatus = 7 à Código de barras e consulta pgt. online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"SegundaViaBoleto", @"")];
            [_lblPaymentOpt2 setText:NSLocalizedString(@"ConsultarPagamento", @"")];
            [_btPaymentOpt2 setTitle:NSLocalizedString(@"Consultar", @"") forState:UIControlStateNormal];
            break;
        case PaymentOptOnlineStatus:
            // OnlineStatus = 8 à Consulta pagamento online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"ConsultarPagamento", @"")];
            [_btPaymentOpt1 setTitle:NSLocalizedString(@"Consultar", @"") forState:UIControlStateNormal];
            [_viewPayment2 removeFromSuperview];
            [_viewDivisor setHidden:YES];
            break;
        case PaymentOptPixActive:
            // TicketAndOnlinePayment = 4 à Código de barras e Pagamento online
            [_lblPaymentOpt1 setText:NSLocalizedString(@"PagamentoPix", @"")];
            [_viewDivisor setHidden:NO];
            [_lblPaymentOpt2 setText:NSLocalizedString(@"PagamentoOnline", @"")];
            break;
        case PaymentOptPixExpired:
            // Ticket = 1 à Código de barras
            [_lblPaymentOpt1 setText:NSLocalizedString(@"PagamentoOnline", @"")];
            [_viewPayment2 removeFromSuperview];
            [_viewDivisor setHidden:YES];
            break;
        default:
            break;
    } /* switch */
    [self stopLoading];

} /* loadView */


- (void) setPaymentValues: (NSString *)payment {
    if ([payment isEqualToString:@""]) {
        return;
    }

    NSNumberFormatter * numberFormatter = [[NSNumberFormatter alloc] init];

    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    NSString * formattedPayment = [numberFormatter stringFromNumber:[NSNumber numberWithFloat:[payment floatValue]]];


    NSMutableAttributedString * attributed = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@\n", NSLocalizedString(@"PagamentoOnline", @"")]];

    [attributed addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"PagamentoOnline", @"") length])];
    [attributed addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"PagamentoOnline", @"") length])];

    NSMutableAttributedString * attributedPrice = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@", formattedPayment]];

    [attributedPrice addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [formattedPayment length])];
    [attributedPrice addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, [formattedPayment length])];

    [attributed appendAttributedString:attributedPrice];

    if (currentComponent == 3) {
        [_lblPaymentOpt1 setAttributedText:attributed];
    } else {
        [_lblPaymentOpt2 setAttributedText:attributed];
    }
} /* setPaymentValues */

- (void) startLoading {
    [_activity startAnimating];
    [_viewButtons setHidden:YES];
    [_activity setHidden:NO];
}

- (void) stopLoading {
    [_activity stopAnimating];
    [_viewButtons setHidden:NO];
    [_activity setHidden:YES];
}
@end
