//
//  ParcelsView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ParcelsView.h"
#import "ParcelsViewCell.h"
#import "PaymentBeans.h"
#import "../Models/PaymentOpt.h"

@interface ParcelsView () {
    NSMutableArray * arrayParcels;
    NSDateFormatter * dateFormat;
    NSNumberFormatter * numberFormatter;
}
@end

const int DAY = 60 * 60 * 60 * 24;

@implementation ParcelsView

- (void) loadView {
    arrayParcels = [[NSMutableArray alloc] init];

    dateFormat = [NSDateFormatter new];
    dateFormat.dateFormat = @"yyyy-MM-dd'T'HH:mm:ss";
    NSLocale * posix = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];

    dateFormat.locale = posix;

    numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setLocale:[NSLocale localeWithLocaleIdentifier:@"pt_BR"]];
    [numberFormatter setNumberStyle:NSNumberFormatterCurrencyStyle];

    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:_bgTable];

    [_lblDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblDescription setTextColor:[BaseView getColor:@"Branco"]];
    [_lblDescription setHidden:YES];
    [_lblTitle setText:NSLocalizedString(@"", @"")];
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"Verde"]];
    [_lblTitle setHidden:YES];
    [_imgIcon setHidden:YES];
} /* loadView */

- (void) unloadView {

}

- (void) loadParcels: (NSArray *)array {
    arrayParcels = [[NSMutableArray alloc] initWithArray:array];
    [_table reloadData];
}

- (UITableViewCell *) tableView: (UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {

    if (indexPath.row == 0) {
        ParcelsViewCell * cell =  (ParcelsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"HeaderParcels"];
        [cell.lblNumParcel setFont:[BaseView getDefatulFont:Micro bold:NO]];
        [cell.lblNumParcel setText:NSLocalizedString(@"Parcela", @"")];
        [cell.lblDate setFont:[BaseView getDefatulFont:Micro bold:NO]];
        [cell.lblDate setText:NSLocalizedString(@"Vencimento", @"")];
        [cell.lblValue setFont:[BaseView getDefatulFont:Micro bold:NO]];
        [cell.lblValue setText:NSLocalizedString(@"ValorParcela", @"")];
        [cell.lblStatus setFont:[BaseView getDefatulFont:Micro bold:NO]];
        [cell.lblStatus setText:NSLocalizedString(@"Status", @"")];
        [cell.bgView setBackgroundColor:[UIColor whiteColor]];
        return cell;
    } else {
        ParcelsViewCell * cell =  (ParcelsViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellParcels"];

        [cell.lblNumParcel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblDate setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblValue setFont:[BaseView getDefatulFont:Small bold:YES]];
        [cell.lblStatus setFont:[BaseView getDefatulFont:Small bold:NO]];

        PaymentBeans * beans = [arrayParcels objectAtIndex:indexPath.row - 1];
        [cell.lblNumParcel setText:[NSString stringWithFormat:@"%d", beans.number]];

        NSString * myString = [[beans.dueDate componentsSeparatedByString:@"T"] objectAtIndex:0];
        NSString * datePayment = [[[[myString componentsSeparatedByString:@"-"] reverseObjectEnumerator] allObjects] componentsJoinedByString:@"/"];

        [cell.lblDate setText:datePayment];
        [cell.lblDate setHidden:NO];

        [cell.lblValue setText:[numberFormatter stringFromNumber:[NSNumber numberWithFloat:beans.amountPayable]]];

        UIColor * bgColor;
        if (beans.status == 1) {
            [cell.lblStatus setText:NSLocalizedString(@"Quitado", @"")];
            bgColor = [BaseView getColor:@"Verde"];
            [cell.lblStatus setTextColor:[BaseView getColor:@"Verde"]];
        } else {

            NSMutableAttributedString * attributedString;
            UIColor * corDefault;
            bool isPix = [beans.codigoTipoModalidadeCobranca isEqual:@"PX"];
            NSDate * dueDate = [dateFormat dateFromString:beans.dueDate];
            bool isExpired = [dueDate compare:[NSDate date]] == NSOrderedAscending;

            if (isPix) {
                if (isExpired) {
                    beans.status = 2;
                    beans.showComponent = PaymentOptPixExpired;
                } else {
                    beans.showComponent = PaymentOptPixActive;
                }
            }

            if (beans.status == 2) {
                attributedString = [[NSMutableAttributedString alloc]
                                    initWithString:NSLocalizedString(@"Atrasado", @"")];
                corDefault = [BaseView getColor:@"Vermelho"];
                bgColor = [BaseView getColor:@"Vermelho"];
            } else if (beans.status == 3) {
                attributedString = [[NSMutableAttributedString alloc]
                                    initWithString:NSLocalizedString(@"EmProcessamento", @"")];
                corDefault = [BaseView getColor:@"AzulClaro"];
                bgColor = [BaseView getColor:@"AzulClaro"];
                [cell.lblStatus setFont:[BaseView getDefatulFont:Nano bold:NO]];
            } else if (beans.status == 4) {
                attributedString = [[NSMutableAttributedString alloc]
                                    initWithString:NSLocalizedString(@"EmAnalise", @"")];
                corDefault = [BaseView getColor:@"AzulClaro"];
                bgColor = [BaseView getColor:@"AzulClaro"];
            } else {
                attributedString = [[NSMutableAttributedString alloc]
                                    initWithString:NSLocalizedString(@"Pendente", @"")];
                corDefault = [BaseView getColor:@"Laranja"];
                bgColor = [BaseView getColor:@"Laranja"];
            }

            NSDate* expiration = [NSDate date];
            if (beans.number == 1) {
                [expiration dateByAddingTimeInterval:DAY * 15];
            } else {
                [expiration dateByAddingTimeInterval:DAY * 8];
            }
            isExpired = [dueDate compare:expiration] == NSOrderedAscending;
            NSString * pagueAgora = NSLocalizedString(@"PagueAgora", @"");
            NSRange pagueAgoraRange = NSMakeRange(0, [pagueAgora length]);
            NSString * prorrogar = NSLocalizedString(@"Prorrogar", @"");
            NSRange prorogarRange = NSMakeRange(0, [prorrogar length]);
            NSString * consultar = NSLocalizedString(@"Consultar", @"");
            NSRange consultarRange = NSMakeRange(0, [prorrogar length]);

            if (beans.showComponent == 1 || beans.showComponent == 4 || beans.showComponent == 7 ||
                (isPix && !isExpired)) {
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];

                if (!isPix) {
                    // adds barcode icon
                    NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
                    textAttachment.image = [UIImage imageNamed:@"boleto_icon.png"];
                    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    [attributedString appendAttributedString:attrStringWithImage];
                    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                }
                NSMutableAttributedString * attrStringFinal = [[NSMutableAttributedString alloc]
                                                               initWithString:pagueAgora];

                [attrStringFinal addAttribute:NSForegroundColorAttributeName
                                        value:corDefault
                                        range:pagueAgoraRange];
                [attrStringFinal addAttribute:NSUnderlineColorAttributeName
                                        value:corDefault
                                        range:pagueAgoraRange];
                [attrStringFinal addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                        range:pagueAgoraRange];
                [attrStringFinal addAttribute:NSFontAttributeName
                                        value:[BaseView getDefatulFont:Nano bold:NO]
                                        range:pagueAgoraRange];

                [attributedString appendAttributedString:attrStringFinal];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:corDefault
                                         range:NSMakeRange(0, attributedString.length)];
            } else if (beans.showComponent == 2  || beans.showComponent == 5 || beans.showComponent == 6) {
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                // extends
                NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
                textAttachment.image = [UIImage imageNamed:@"red_arrow.png"];
                NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                [attributedString appendAttributedString:attrStringWithImage];
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                NSMutableAttributedString * attrStringFinal = [[NSMutableAttributedString alloc]
                                                               initWithString:[NSString stringWithFormat:@"%@", prorrogar]];
                [attrStringFinal addAttribute:NSForegroundColorAttributeName
                                        value:corDefault
                                        range:prorogarRange];

                [attrStringFinal addAttribute:NSUnderlineColorAttributeName
                                        value:corDefault
                                        range:prorogarRange];
                [attrStringFinal addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                        range:prorogarRange];
                [attrStringFinal addAttribute:NSFontAttributeName
                                        value:[BaseView getDefatulFont:Nano bold:NO]
                                        range:prorogarRange];
                [attributedString appendAttributedString:attrStringFinal];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:corDefault
                                         range:NSMakeRange(0, attributedString.length)];
            } else if (beans.showComponent == 3 || (isPix && isExpired)) {
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                // online payment

                if (!isPix) {
                    NSTextAttachment * textAttachment = [[NSTextAttachment alloc] init];
                    textAttachment.image = [UIImage imageNamed:@"boleto_icon.png"];
                    NSAttributedString * attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
                    [attributedString appendAttributedString:attrStringWithImage];
                    [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@" "]];
                }
                NSMutableAttributedString * attrStringFinal = [[NSMutableAttributedString alloc]
                                                               initWithString:pagueAgora];
                [attrStringFinal addAttribute:NSForegroundColorAttributeName
                                        value:corDefault
                                        range:pagueAgoraRange];
                [attrStringFinal addAttribute:NSUnderlineColorAttributeName
                                        value:corDefault
                                        range:pagueAgoraRange];
                [attrStringFinal addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                        range:pagueAgoraRange];
                [attrStringFinal addAttribute:NSFontAttributeName
                                        value:[BaseView getDefatulFont:Nano bold:NO]
                                        range:pagueAgoraRange];
                [attributedString appendAttributedString:attrStringFinal];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:corDefault
                                         range:NSMakeRange(0, attributedString.length)];
            } else if (beans.showComponent == 8) {
                // consulta online
                [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
                NSMutableAttributedString * attrStringFinal = [[NSMutableAttributedString alloc]
                                                               initWithString:consultar];
                [attrStringFinal addAttribute:NSForegroundColorAttributeName
                                        value:corDefault range:consultarRange];
                [attrStringFinal addAttribute:NSUnderlineColorAttributeName
                                        value:corDefault range:consultarRange];
                [attrStringFinal addAttribute:NSUnderlineStyleAttributeName
                                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle]
                                        range:consultarRange];
                [attrStringFinal addAttribute:NSFontAttributeName
                                        value:[BaseView getDefatulFont:Nano bold:NO]
                                        range:consultarRange];
                [attributedString appendAttributedString:attrStringFinal];
                [attributedString addAttribute:NSForegroundColorAttributeName
                                         value:corDefault
                                         range:NSMakeRange(0, attributedString.length)];
            }

            [cell.lblStatus setAttributedText:attributedString];
            [cell.lblStatus setTextColor:corDefault];
        }

        [cell.bgView setBackgroundColor:[bgColor colorWithAlphaComponent:0.20f]];

        return cell;
    }

} /* tableView */

- (NSInteger) numberOfSectionsInTableView: (UITableView *)tableView {
    return 1;
}

- (NSInteger) tableView: (UITableView *)tableView numberOfRowsInSection: (NSInteger)section {
    return [arrayParcels count] + 1;
}

- (CGFloat) tableView: (UITableView *)tableView heightForHeaderInSection: (NSInteger)section {
    return 0;
}

- (UIView *) tableView: (UITableView *)tableView viewForHeaderInSection: (NSInteger)section {
    return nil;

} /* tableView */

- (CGFloat) tableView: (UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 25;
    } else {
        return 60;
    }
}

- (IBAction) closePopUp: (id)sender {
    [_popupBarCode setHidden:YES];
}

- (void) hideBarCode {
    [_popupBarCode setHidden:YES];
}

- (void) showPopUpLoading {
    [_activity setHidden:NO];
    [_activity startAnimating];
    [_popupBarCode setHidden:NO];
    [_btOk setHidden:YES];
}

- (void) showBarCode: (NSString *)barcode {
    [_lblDescription setText:[NSString stringWithFormat:@"%@\n\n%@", NSLocalizedString(@"CódigoDeBarrasMsg", @""), barcode]];
    [_lblDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblDescription setTextColor:[BaseView getColor:@"Branco"]];
    [_lblDescription setHidden:NO];
    [_lblTitle setText:NSLocalizedString(@"CódigoDeBarras", @"")];
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"Verde"]];
    [_lblTitle setHidden:NO];
    [_imgIcon setHidden:NO];
    [_btOk setHidden:NO];
    [_activity setHidden:YES];

    [_activity stopAnimating];

}

@end
