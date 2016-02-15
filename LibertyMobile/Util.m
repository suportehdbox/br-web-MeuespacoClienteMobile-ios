//
//  Util.m
//  LibertyMobile
//
//  Created by Fernando Balthazar on 8/27/12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "Util.h"
#import "TextFieldTableViewCell.h"
#import "TextViewFieldTableViewCell.h"
#import "BotaoAmareloTableViewCell.h"


@implementation Util

//+(void)initCustomNavigationBar:(UINavigationBar *)customNavigationBar {
//    UIImage *image = [UIImage imageNamed:@"bar-header-lm.png"];
//    [customNavigationBar setBackgroundImage:image forBarMetrics:UIBarStyleDefault];
//}

+(BOOL) fieldIsValidString:(NSString *)theField andMinChars:(NSInteger)minChars andMaxChars:(NSInteger)maxChars 
{
    //Trim any whitespace
    theField = [theField stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    //Look for empty field
    if(theField == nil)
    {
        return NO;
    }
    //Look for Minimum Characters
    else if([theField length] < minChars)    
    {
        return NO;
    }
    //Look for Maximum Characters
    else if([theField length] > maxChars)
    {
        return NO;
    }
    
    //The field is valid
    return YES;
}

+(void) alertError:(NSError *) error
{
	NSLog(@"Unresolved error %@", error);
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Hit Home Button to Exit" 
													message:[NSString stringWithFormat:@"An error has occurred.:\n\nFully terminate the app from background and reopen.\n\n %@.", [error localizedDescription]]
												   delegate:self 
										  cancelButtonTitle:@"OK" 
										  otherButtonTitles:nil];
	
	[alert show];
	[alert release];
}


+(UIBarButtonItem *) addCustomButtonNavigationBar:(id)target action:(SEL)action imageName:(NSString *)imageName
{
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    UIImage *image = [UIImage imageNamed:imageName inBundle:bundle compatibleWithTraitCollection:[UITraitCollection traitCollectionWithDisplayScale:[UIScreen mainScreen].scale]];
//    UIImage *image = [UIImage imageNamed:imageName];

    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake(0, 0, 70, 60);
    [face setImageEdgeInsets:UIEdgeInsetsMake(15, 0, 0, 0)];
    [face setImage:image forState:UIControlStateNormal];
    [face addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];

    UIBarButtonItem *Button = [[UIBarButtonItem alloc] initWithCustomView:face] ;

    return Button;
}

+(void) addBackButtonNavigationBar:(id)target action:(SEL)action
{
    // Botão Voltar - Seta
    UIImage *image = [UIImage imageNamed:@"seta.png"];
    UIButton *face = [UIButton buttonWithType:UIButtonTypeCustom];
    face.bounds = CGRectMake(0, 0, 30, 30);
    [face setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [face setImage:image forState:UIControlStateNormal];
    [face addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *closeButton = [[UIBarButtonItem alloc] initWithCustomView:face] ;
    ((UIViewController*)target).navigationItem.leftBarButtonItem = closeButton;
    [closeButton release];
}

+(void)callAlert:(id)target alertTitle:(NSString*)alertTitle  alertNumber:(NSString*)alertNumber
{
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:alertTitle
													message:alertNumber 
												   delegate:target 
										  cancelButtonTitle:@"Cancelar" 
										  otherButtonTitles:@"Ligar", nil];
    
	[alert show];
	[alert release];
}

+(void)callNumber:(id)target phoneNumber:(NSString*)phoneNumber
{
    NSString *numberToCall = [NSString stringWithFormat:@"tel:%@", phoneNumber];
    NSString *webReadyNumberToCall = [numberToCall stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:webReadyNumberToCall]];
}

+(NSString*)fmtNSDateToString:(NSDate*)dataSource dateFormatter:(NSDateFormatter*)dateFormatter
{
    if (dateFormatter == nil) {
        dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    }

    NSString* textDate = [[[NSString alloc] init] autorelease];// @"";

    if (dataSource != nil) {
        textDate = [NSString stringWithFormat:@"%@", [dateFormatter stringFromDate:dataSource]];
    }
    
    return textDate;
}

+(NSDate*)convertStringToNSDate:(NSString*)dataSource  dateFormatter:(NSDateFormatter*)dateFormatter
{
    if (dateFormatter == nil) {
        dateFormatter = [[[NSDateFormatter alloc] init] autorelease];
        [dateFormatter setDateFormat:@"dd/MM/yyyy"];
    }
    
    NSDate *dateFromString = [dateFormatter dateFromString:dataSource];
    
    return dateFromString;
}


+(NSString*)fmtDoubleToString:(double)numberSource
{
    NSNumber* dValor = [[NSNumber alloc] initWithDouble:numberSource];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setPositiveFormat:@"#,##0.00"];
    [numberFormatter setDecimalSeparator:@","];     //Separador de Decimal
    [numberFormatter setGroupingSeparator:@"."];    //Separador de Milhares
    NSString* textNumber = [numberFormatter stringFromNumber:dValor];
    [numberFormatter release];
    [dValor release];
    
    return textNumber;
}

+(int)getCountSectionArray:(int)numSection sourceArray:(NSMutableArray*)sourceArray {
    int iNumber = 0;
    
    for (int iCont = 0; iCont < [sourceArray count]; iCont++) {
        NSMutableDictionary* dict = [sourceArray objectAtIndex:iCont];
        NSInteger iSection = [[dict objectForKey:@"section"] intValue];
        if (iSection == numSection) 
            iNumber++;
    }
    
    return iNumber;
}

+(int)getPositionSectionArray:(int)numSection numRow:(int)numRow sourceArray:(NSMutableArray*)sourceArray {
    int iNumber = -1;
    int iPositionReal = -1;
    
    for (int iCont = 0; iCont < [sourceArray count]; iCont++) {
        NSMutableDictionary* dict = [sourceArray objectAtIndex:iCont];
        NSInteger iSection = [[dict objectForKey:@"section"] intValue];
        if (iSection == numSection)
            iNumber++;
        if (iNumber == numRow) {
            iPositionReal = iCont;
            break;
        }
    }
    
    return iPositionReal;
}

+(UIColor*)getColorHeader
{
    return [[[UIColor alloc] initWithRed:51.0f/255.0f green:102.0f/255.0f blue:153.0f/255.0f alpha:1.0f] autorelease];
}

+(void)loadHtml:(NSString*)htmlName webViewControl:(UIWebView*)webViewControl {
    NSString *webViewPath = [[NSBundle mainBundle] pathForResource:htmlName ofType:@"html"];
    NSString *webViewString = [NSString stringWithContentsOfFile:webViewPath encoding:NSUTF8StringEncoding error:NULL];
    [webViewControl loadHTMLString:webViewString baseURL:nil];
    [webViewControl setBackgroundColor:[UIColor clearColor]];
    [webViewControl setUserInteractionEnabled:NO];
    [webViewControl setOpaque:NO];
    [webViewControl setScalesPageToFit:NO];
}


+(UIView*)getViewButtonTableView:(id)target action:(SEL)action textButton:(NSString*)textButton imageName:(NSString *)imageName {

    //CGRectMake(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
    UIView* retView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 44.0)];
    [retView setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight ];

    [retView setBackgroundColor:[UIColor clearColor]];

    UIButton* buttonTable = [UIButton buttonWithType:UIButtonTypeCustom];
    [buttonTable setBackgroundImage:[[UIImage imageNamed:imageName] stretchableImageWithLeftCapWidth:12.0 topCapHeight:0.0] forState:UIControlStateNormal];
    buttonTable.frame = CGRectMake(0, 0.0, 320.0, 44.0);
    
    [buttonTable setAutoresizingMask :UIViewAutoresizingFlexibleBottomMargin
                                    | UIViewAutoresizingFlexibleLeftMargin
                                    | UIViewAutoresizingFlexibleRightMargin
                                    | UIViewAutoresizingFlexibleTopMargin
                                    | UIViewAutoresizingFlexibleWidth ];
    
    [buttonTable setTitleColor:[self getColorHeader] forState:UIControlStateNormal];
    [buttonTable setTitle:textButton forState:UIControlStateNormal];
    [buttonTable addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [buttonTable.titleLabel setFont:[UIFont boldSystemFontOfSize:15.0]];
    
    [retView addSubview:buttonTable];

    return [retView autorelease];
}

+(void)openKeyBoardTableView:(UITableViewCell*)tableViewCell {
    NSObject *subview;
    NSEnumerator *enumerator = [tableViewCell.subviews objectEnumerator];
    while ((subview = [enumerator nextObject])) {
        if ([subview isKindOfClass:[UIView class]]) {
            NSObject *cellSubview;
            NSEnumerator *cellContentsEnumerator = [((UIView *) subview).subviews objectEnumerator];
            while ((cellSubview = [cellContentsEnumerator nextObject])) {
                if ([cellSubview isKindOfClass:[UITextField class]]) {
                    [(UITextView *) cellSubview becomeFirstResponder];
                    return;
                }
            }
        }
    }
}

+(int)getFieldLengthByFieldTagArray:(int)tagFind sourceArray:(NSMutableArray*)sourceArray {
    for (int iCont = 0; iCont < [sourceArray count]; iCont++) {
        NSMutableDictionary* dict = [sourceArray objectAtIndex:iCont];
        NSInteger iTag = [[dict objectForKey:@"tag"] intValue];
        if (iTag == tagFind) {
            NSInteger iLength = [[dict objectForKey:@"length"] intValue];
            return iLength;
        }
    }
    
    return -1;
}


+(UIView *) obtainUIViewSuperview:(UIView *) aView withClass:(Class) aClass {
	if (aView == nil) {
		return nil;
	}
	
	UIView *currentSuperview = [aView superview];
	while (currentSuperview) {
		if ([currentSuperview isKindOfClass:aClass]) {
			return (UIView *) currentSuperview;
		}
		currentSuperview = [currentSuperview superview];
	}
	
	return nil;	
}

+(UITableView *) obtainSuperviewUITableView:(UIControl *) aControl {
	return (UITableView *) [Util obtainUIViewSuperview:aControl withClass:[UITableView class]];
}

+(UITableViewCell *) obtainSuperviewUITableViewCell:(UIControl *) aControl {
	return (UITableViewCell *) [Util obtainUIViewSuperview:aControl withClass:[UITableViewCell class]];
}

+(BOOL) changeResponder:(int) tagChange forTextField:(UIControl *) activeTextField withTagRange: (NSRange) activeTagRange {
	UITableView *tableView = [Util obtainSuperviewUITableView: activeTextField];
    
	NSUInteger tag = activeTextField.tag;
    
	UIResponder* nextResponder = (UIResponder *)[tableView viewWithTag:tag + tagChange];
	
	if (nextResponder && tag + tagChange > 0) {
		if ([nextResponder canBecomeFirstResponder]) {
			if (! [nextResponder becomeFirstResponder]) {
				NSLog(@"Tag %d of type %@ failed to become first responder", tag + tagChange, [nextResponder class]);
				// Recover from failed attempt to use offscreen field.  Take any text field that responds
				for (int i = activeTagRange.location ; i < activeTagRange.length; i++) {
					nextResponder = (UIResponder *)[tableView viewWithTag:i];
					if ([nextResponder becomeFirstResponder]) {
						return YES;
					}
				}
			}
		}
		else {
			NSLog(@"Tag %d of type %@ cannot become first responder", tag + tagChange, [nextResponder class]);			
		}
	}
	
    
	return NO;
}

+ (void) makeTableCellVisibleFromSubview:(UIControl *) aUIView usingScrollPosition:(UITableViewScrollPosition) scrollPosition
{
	UITableView *uiTableView = (UITableView *) [Util obtainSuperviewUITableView:aUIView];
	UITableViewCell *uiTableViewCell = (UITableViewCell *) [Util obtainSuperviewUITableViewCell:aUIView];
	NSIndexPath *indexPathToCell = [uiTableView indexPathForCell:uiTableViewCell];
	
	//Cell to Middle is preferred over recover scroll to rectangle
	if (indexPathToCell)  {
		[uiTableView scrollToRowAtIndexPath:indexPathToCell atScrollPosition:scrollPosition animated:YES];
	}
	else {
		[uiTableView scrollRectToVisible:[aUIView frame] animated:YES];
	}
}

+ (void) makeTableCellControlVisible: (UIControl *) view {
	[self makeTableCellVisibleFromSubview:view usingScrollPosition:UITableViewScrollPositionMiddle];
}

+ (void) dropTableBackgroudColor:(UITableView *)tableView {
    [tableView setBackgroundView:nil];
}

+(BOOL)checkCPF:(NSString *)cpf {
    
    NSUInteger i, firstSum, secondSum, firstDigit, secondDigit, firstDigitCheck, secondDigitCheck;
    
    if(cpf == nil) return NO;
    
    if ([cpf length] != 11) return NO;
 
    if (([cpf isEqual:@"00000000000"]) || ([cpf isEqual:@"11111111111"]) || ([cpf isEqual:@"22222222222"])|| ([cpf isEqual:@"33333333333"])|| ([cpf isEqual:@"44444444444"])|| ([cpf isEqual:@"55555555555"])|| ([cpf isEqual:@"66666666666"])|| ([cpf isEqual:@"77777777777"])|| ([cpf isEqual:@"88888888888"])|| ([cpf isEqual:@"99999999999"])) return NO;
    
    firstSum = 0;
    
    for (i = 0; i <= 8; i++) {
        firstSum += [[cpf substringWithRange:NSMakeRange(i, 1)] intValue] * (10 - i);
    }
    
    if (firstSum % 11 < 2)
        firstDigit = 0;
    else
        firstDigit = 11 - (firstSum % 11);
    
    secondSum = 0;
    
    for (i = 0; i <= 9; i++) {
        secondSum = secondSum + [[cpf substringWithRange:NSMakeRange(i, 1)] intValue] * (11 - i);
    }
    
    if (secondSum % 11 < 2)
        secondDigit = 0;
    else
        secondDigit = 11 - (secondSum % 11);
    
    firstDigitCheck = [[cpf substringWithRange:NSMakeRange(9, 1)] intValue];
    secondDigitCheck = [[cpf substringWithRange:NSMakeRange(10, 1)] intValue];
    
    if ((firstDigit == firstDigitCheck) && (secondDigit == secondDigitCheck))
        return YES;
    return NO;
}

+ (BOOL)checkCnpj:(NSString*) cnpj
{
    if(cnpj == nil) return NO;
    
    if ([cnpj length] != 14) return NO;
    
    if (   [cnpj isEqualToString:@"00000000000000"] || [cnpj isEqualToString:@"11111111111111"] || [cnpj isEqualToString:@"22222222222222"]
        || [cnpj isEqualToString:@"33333333333333"] || [cnpj isEqualToString:@"44444444444444"] || [cnpj isEqualToString:@"55555555555555"]
        || [cnpj isEqualToString:@"66666666666666"] || [cnpj isEqualToString:@"77777777777777"] || [cnpj isEqualToString:@"88888888888888"]
        || [cnpj isEqualToString:@"99999999999999"]) return NO;
    
    NSInteger soma = 0, peso;
    NSInteger digito_verificador_13 = [[cnpj substringWithRange:NSMakeRange(12, 1)] integerValue];
    NSInteger digito_verificador_14 = [[cnpj substringWithRange:NSMakeRange(13, 1)] integerValue];
    NSInteger digito_verificador_13_correto;
    NSInteger digito_verificador_14_correto;
    
    //Verificação 13 Digito
    peso=2;
    for (int i=11; i>=0; i--)
    {
        soma = soma + ( [[cnpj substringWithRange:NSMakeRange(i, 1)] integerValue] * peso);
        peso = peso+1;
        if (peso == 10) {
            peso = 2;
        }
    }
    
    if (soma % 11 == 0 || soma % 11 == 1) {
        digito_verificador_13_correto = 0;
    }
    else{
        digito_verificador_13_correto = 11 - soma % 11;
    }
    
    //Verificação 14 Digito
    soma=0;
    peso=2;
    for (int i=12; i>=0; i--) {
        
        soma = soma + ( [[cnpj substringWithRange:NSMakeRange(i, 1)] integerValue] * peso);
        
        peso = peso+1;
        
        if (peso == 10) {
            peso = 2;
        }
    }
    
    if (soma % 11 == 0 || soma % 11 == 1) {
        digito_verificador_14_correto = 0;
    }else{
        digito_verificador_14_correto = 11 - soma % 11;
    }
    
    //Retorno
    if (digito_verificador_13_correto == digito_verificador_13 && digito_verificador_14_correto == digito_verificador_14)
        return YES;
    
    return NO;
}

+(NSDate*)addDate:(NSDate*)dataSource days:(int)days
{
    return [dataSource dateByAddingTimeInterval:60*60*24*days];
}

+(NSDate*)getDateFromJSON:(NSString *)dateString {
    int startPos = [dateString rangeOfString:@"("].location + 1;
    int endPos = [dateString rangeOfString:@")"].location;
    NSRange range = NSMakeRange(startPos, endPos - startPos);
    unsigned long long milliseconds = [[dateString substringWithRange:range] longLongValue];
    NSTimeInterval interval = milliseconds / 1000;
    return [NSDate dateWithTimeIntervalSince1970:interval];
}

+(NSString*)getColumnDict:(NSDictionary*)dict columnName:(NSString*)columnName {
    if ((NSNull *)[dict objectForKey:columnName] == [NSNull null]) return @"";
    return [dict objectForKey:columnName];
}

+(void)viewMsgErrorConnection:(id)target codeError:(NSError*)codeError {

    NSString *msg = nil;//[[NSString alloc] init];
    NSInteger code = codeError.code;

    switch (code) {
        case 0:
            msg = @"Código de acesso não recebido. Verifique se a sua conexão de rede está ativa e tente novamente.";
            break;
        case 1:
            msg = @"Dados da apólice não recebido. Verifique se a sua conexão de rede está ativa e tente novamente.";
            break;
        case 2:
            msg = @"Não pode gerar nova senha. Verifique se a sua conexão de rede está ativa e tente novamente.";
            break;
        default:
            msg = @"Não pode conectar ao serviço. Verifique se a sua conexão de rede está ativa e tente novamente.";
           break;
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil
                                                    message:msg
                                                   delegate:nil
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}

+(void)formatInput:(UITextField*)aTextField string:(NSString*)aString range:(NSRange)aRange maskValid:(NSString *)maskValid
{
    
    //Copying the contents of UITextField to an variable to add new chars later
    NSString* value = aTextField.text;
    
    NSString* formattedValue = value;
    
    //Se o tamanho dos caracteres digitados forem maior que a mascara ou não for delete
    if ([value length] + 1 > [maskValid length] && ![aString isEqualToString:@""]) return;
    
    //Make sure to retrieve the newly entered char on UITextField
    aRange.length = 1;
    
    NSString* _mask = [maskValid substringWithRange:aRange];
    
    BOOL bInsertCaracterSpecial = NO;
    
    //Press delete
    if ([aString isEqualToString:@""] && [formattedValue length] > 0) {
        
        int iDelete = 1;
        int iLocation = aRange.location - 1;

        //Verificar se o caracter anterior é um caracter especial
        if (iLocation > 0) {
            NSString *regex = @"[ˆA-Z0-9a-z@]";
            NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (! [regextest evaluateWithObject:[maskValid substringWithRange:NSMakeRange(iLocation, 1)]]) {
                iDelete = 2;
            }
        }
        
        formattedValue = [formattedValue substringWithRange:NSMakeRange(0, [formattedValue length] - iDelete)];
        aTextField.text = formattedValue;
        return;
    }
    
    //Verificando se o caracter digitado é valido ou não
    NSString *regex = @"";

    if ([[maskValid substringWithRange:NSMakeRange(aRange.location, 1)] isEqualToString:@"9"]) {
        regex = @"[ˆ0-9]";
    }
    else if ([[maskValid substringWithRange:NSMakeRange(aRange.location, 1)] isEqualToString:@"@"]) {
        regex = @"[ˆA-Z0-9a-z]";
    }
    
    NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if (! [regextest evaluateWithObject:[aString substringWithRange:NSMakeRange(0, 1)]]) {
        return;
    }

    if (_mask != nil) {
        //Verificando se o proximo caracter é diferente de números
        if (aRange.location + 1 < [maskValid length]) {
            NSString *regex = @"[ˆA-Z0-9a-z@]";
            NSPredicate *regextest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
            if (! [regextest evaluateWithObject:[maskValid substringWithRange:NSMakeRange(aRange.location + 1, 1)]]) {
                bInsertCaracterSpecial = YES;
            }
        }

    }

    //Adding the user entered character
    formattedValue = [formattedValue stringByAppendingString:aString];
    
    if (bInsertCaracterSpecial) formattedValue = [formattedValue stringByAppendingString:[maskValid substringWithRange:NSMakeRange(aRange.location + 1, 1)]];
    
    //Refreshing UITextField value
    aTextField.text = formattedValue;
}

+(BOOL)validateEmail:(NSString *)emailStr {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:emailStr];
}


+(UITableViewCell*)getViewButtonTableViewCell:(id)target action:(SEL)action textButton:(NSString*)textButton tableView:(UITableView *)tableView
{
    BotaoAmareloTableViewCell *cell = (BotaoAmareloTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cellButton"];
    
    [cell.btnAmarelo addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [cell.btnAmarelo setTitle:textButton forState:UIControlStateNormal];
    
    // Nescessario para remover a borda branca da celula do botao:
    UIView *backView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
    backView.backgroundColor = [UIColor clearColor];
    cell.backgroundView = backView;
    
    return cell;
}

+ (UIColor *)colorwithHexString:(NSString *)hexStr alpha:(CGFloat)alpha;
{
    //-----------------------------------------
    // Convert hex string to an integer
    //-----------------------------------------
    unsigned int hexint = 0;
    
    // Create scanner
    NSScanner *scanner = [NSScanner scannerWithString:hexStr];
    
    // Tell scanner to skip the # character
    [scanner setCharactersToBeSkipped:[NSCharacterSet
                                       characterSetWithCharactersInString:@"#"]];
    [scanner scanHexInt:&hexint];
    
    //-----------------------------------------
    // Create color object, specifying alpha
    //-----------------------------------------
    UIColor *color =
    [UIColor colorWithRed:((CGFloat) ((hexint & 0xFF0000) >> 16))/255
                    green:((CGFloat) ((hexint & 0xFF00) >> 8))/255
                     blue:((CGFloat) (hexint & 0xFF))/255
                    alpha:alpha];
    
    return color;
}

@end
