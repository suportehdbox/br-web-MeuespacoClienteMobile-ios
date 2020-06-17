//
//  ForgotPasswordView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotPasswordView.h"

@implementation ForgotPasswordView
@synthesize btLoginLater;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(_btPrivacy.frame) + 10)];
    //    [_scrollView setFrame:self.frame];
    [_widthImage setConstant:CGRectGetMaxX(self.frame)];
    [self updateConstraintsIfNeeded];
    CGRect windowRect = self.window.frame;
    if(windowRect.size.height <= 568){
        [_bottomSpace setConstant:20];
    }
    UIImage *originalImage = [UIImage imageNamed:@"seta"];
    UIImage *scaledImage =
    [UIImage imageWithCGImage:[originalImage CGImage]
                        scale:(originalImage.scale * 1.5)
                  orientation:(originalImage.imageOrientation)];
    [btLoginLater setImage:[self imageWithColor:scaledImage color:[BaseView getColor:@"AzulLogin"]] forState:UIControlStateNormal];
    [btLoginLater.titleLabel setFont:[BaseView getDefatulFont:Nano bold:false]];
    [btLoginLater setTitleEdgeInsets:UIEdgeInsetsMake(0, 5, 0, 0)];
    [btLoginLater customizeBorderColor:[BaseView getColor:@"CinzaBotao"] borderWidth:1 borderRadius:10];
    [btLoginLater setTitle:NSLocalizedString(@"LogarDepois",@"") forState:UIControlStateNormal];
    [btLoginLater setTitleColor:[BaseView getColor:@"AzulLogin"] forState:UIControlStateNormal];
    [btLoginLater setBackgroundColor:[BaseView getColor:@"CinzaBotao"]];
    
    NSMutableAttributedString *instructions = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"RecuperacaoSenha", @"")];
    
    [instructions addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSRangeFromString(NSLocalizedString(@"RecuperacaoSenha", @""))];
    [instructions addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"RecuperacaoSenha", @"") length])];
    
//    NSRange rangeBold = [NSLocalizedString(@"InstrucoesLogin", @"") rangeOfString:@"TOUCH ID"];
//    [instructions addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range: rangeBold];
    [_lblRegister setAttributedText:instructions];
    
    [_txtEmail setPlaceholder:NSLocalizedString(@"Email", @"")];
    [_txtEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmail setDelegate:self];
    
    [_txtCpf setPlaceholder:NSLocalizedString(@"CPF", @"")];
    [_txtCpf setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtCpf setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtCpf setDelegate:self];
    
    
    
    if ([Config isAliroProject]) {
        [_btLogin setTitle:NSLocalizedString(@"Enviar", @"") forState:UIControlStateNormal];
        [_btLogin setBorderColor:[BaseView getColor:@"CorBotoes"]];
        [_btLogin setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    }else{
        [_btLogin setTitle:NSLocalizedString(@"Enviar", @"") forState:UIControlStateNormal];
        [_btLogin setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btLogin setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_btLogin setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }

    
    
    NSMutableAttributedString *registerTxt = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FraseCadastrar", @"")];
    
    [registerTxt addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrar", @"") length])];
    [registerTxt addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrar", @"") length])];
    
    
    
    
    NSRange rangeRegister = [NSLocalizedString(@"FraseCadastrar", @"") rangeOfString:@"?"];
    
    rangeRegister.length = [NSLocalizedString(@"FraseCadastrar", @"")  length] - rangeRegister.location - 2;
    rangeRegister.location +=2;
    
    [registerTxt addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:rangeRegister];
    [registerTxt addAttribute:NSUnderlineColorAttributeName
                        value:[BaseView getColor:@"AzulEscuro"] range:rangeRegister];
    [registerTxt addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:rangeRegister];
    
    
    [_btRegister setAttributedTitle:registerTxt forState:UIControlStateNormal];
    
    
    NSMutableAttributedString *privacy = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Politica", @"")];
    [privacy addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    [privacy addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Nano bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    [privacy addAttribute:NSUnderlineColorAttributeName
                    value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    [privacy addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    
    [_btPrivacy setAttributedTitle:privacy forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtCpf){
        [_txtEmail becomeFirstResponder];
    }else{
        [_btLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == _txtCpf){
        int limit = 13;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    return YES;
}
- (void)registerForKeyboardNotifications
{
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillBeHidden:)
                                                 name:UIKeyboardWillHideNotification object:nil];
    
}

-(void) unRegisterKeyboard{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

// Called when the UIKeyboardDidShowNotification is sent.
- (void)keyboardWasShown:(NSNotification*)aNotification
{
    NSDictionary* info = [aNotification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    //    float posY = self.frame.size.height - kbSize.height - 15;
    
    CustomTextField *currentText;
    if(_txtEmail.isEditing){
        currentText = _txtEmail;
    }else if(_txtCpf.isEditing){
        currentText = _txtCpf;
    }
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
    CGRect aRect = self.frame;
    aRect.size.height -= kbSize.height - _scrollView.contentOffset.y;
    if (!CGRectContainsPoint(aRect, currentText.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, currentText.frame.origin.y-kbSize.height);
        if(scrollPoint.y > 0 ){
            [_scrollView setContentOffset:scrollPoint animated:YES];
        }
    }
    
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
}

-(void) hideKeyboard{
    [self tapTexts];
}

-(void) tapTexts{
    if(_txtEmail.isEditing){
        [_txtEmail resignFirstResponder];
    }else if(_txtCpf.isEditing){
        [_txtCpf resignFirstResponder];
    }
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    if(_txtEmail.isEditing || _txtCpf.isEditing){
        [self tapTexts];
    }
}

-(void) unloadView{
    [self unRegisterKeyboard];
    [_txtCpf unloadView];
    [_txtEmail unloadView];
    
    
}

- (UIImage *)imageWithColor:(UIImage*)iamge color:(UIColor *)color1
{
    UIGraphicsBeginImageContextWithOptions(iamge.size, NO, iamge.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, iamge.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, iamge.size.width, iamge.size.height);
    CGContextClipToMask(context, rect, iamge.CGImage);
    [color1 setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}


-(NSString*) getEmail{
    return [_txtEmail text];
}

-(void) showEmailError:(NSString*)message{
    [_txtEmail showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}


-(NSString*) getCpf{
    return [_txtCpf text];
}


-(void) showCpfError:(NSString*)message{
    [_txtCpf showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

-(void) showLoading{
    [_txtEmail setHidden:YES];
    [_btLogin setHidden:YES];
    [_btRegister setHidden:YES];
    [_btPrivacy setHidden:YES];
    [_txtCpf setHidden:YES];
    [btLoginLater setHidden:YES];
    [_acitivty setHidden:NO];
    [_acitivty startAnimating];
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void) stopLoading{
    [_txtEmail setHidden:NO];
    [_txtCpf setHidden:NO];
    [_btLogin setHidden:NO];
    [_btRegister setHidden:NO];
    [_btPrivacy setHidden:NO];
    [btLoginLater setHidden:NO];
    [_acitivty setHidden:YES];
    [_acitivty stopAnimating];
    
}
@end
