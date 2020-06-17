//
//  ChangePasswordView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 10/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ChangePasswordView.h"
@interface ChangePasswordView(){
    UITextField * currentTextField;
}
@end
@implementation ChangePasswordView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    
    [_widthBox setConstant:CGRectGetMaxX(self.frame)- 16];
    [_heightScrollView setConstant:25];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:_viewFields];
    
    
    [self stopLoading];
    
    [_txtCpf setPlaceholder:NSLocalizedString(@"CPF", @"")];
    [_txtCpf setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtCpf setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtCpf setDelegate:self];
    
    
    NSMutableAttributedString *instructionsPWD = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"InstrucoesPassword", @"")];
    
    [instructionsPWD addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSRangeFromString(NSLocalizedString(@"InstrucoesPassword", @""))];
    [instructionsPWD addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSRangeFromString(NSLocalizedString(@"InstrucoesPassword", @""))];
    
//    [instructionsPWD addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, 8)];
    
    [_lblInstructionsPassword setAttributedText:instructionsPWD];
    [_lblInstructionsPassword setAdjustsFontSizeToFitWidth:YES];
    [_lblInstructionsPassword setMinimumScaleFactor:0.3];
    [_lblInstructionsPassword setNumberOfLines:3];
    

    [_txtOldPwd setPlaceholder:NSLocalizedString(@"SenhaAtual", @"")];
    [_txtOldPwd setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtOldPwd setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtOldPwd setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtOldPwd setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtOldPwd setKeyboardType:UIKeyboardTypeDefault];
    [_txtOldPwd setSecureTextEntry:YES];
    [_txtOldPwd setDelegate:self];
    
    [_txtPwd setPlaceholder:NSLocalizedString(@"NovaSenha", @"")];
    [_txtPwd setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPwd setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPwd setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPwd setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPwd setKeyboardType:UIKeyboardTypeDefault];
    [_txtPwd setSecureTextEntry:YES];
    [_txtPwd setDelegate:self];
    
    [_txtRepeatPwd setPlaceholder:NSLocalizedString(@"ConfirmarNovaSenha", @"")];
    [_txtRepeatPwd setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtRepeatPwd setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatPwd setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatPwd setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatPwd setKeyboardType:UIKeyboardTypeDefault];
    [_txtRepeatPwd setSecureTextEntry:YES];
    [_txtRepeatPwd setDelegate:self];

    
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setText:NSLocalizedString(@"TrocarSenha", @"")];
    
    
    [_btSend setTitle:NSLocalizedString(@"BtTrocarSenha", @"") forState:UIControlStateNormal];
    [_btSend setBorderColor:[BaseView getColor:@"CorBotoes"]];
    if(![Config isAliroProject]){
        [_btSend setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btSend setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    [_btSend setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    
     [_lblSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
     [_lblSuccess setTextColor:[BaseView getColor:@"Verde"]];
     [_lblSuccess setText:NSLocalizedString(@"SenhaAlterada", @"")];
    
    [_btSucess setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    if(![Config isAliroProject]){
        [_btSucess setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btSucess setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btSucess setBorderColor:[BaseView getColor:@"Verde"]];
        [_btSucess customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    [NSTimer scheduledTimerWithTimeInterval:0.2f target:self selector:@selector(loadInfo) userInfo:nil repeats:NO];

}
-(void) loadInfo{
    [_userInfoView loadView];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtCpf){
        [_txtPwd becomeFirstResponder];
    }else if(textField == _txtPwd){
        [_txtRepeatPwd becomeFirstResponder];
    }else{
        [_btSend sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField =textField;
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
    
    float posY = self.frame.size.height - kbSize.height - 15;
    
    
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0.0);
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    
    // If active text field is hidden by keyboard, scroll it so it's visible
    // Your application might not need or want this behavior.
//    CGRect aRect = self.frame;
//    aRect.size.height -= kbSize.height - _scrollView.contentOffset.y;
    if(CGRectGetMaxY(currentTextField.frame) > posY){
//    if (!CGRectContainsPoint(aRect, currentTextField.frame.origin) ) {
        CGPoint scrollPoint = CGPointMake(0.0, currentTextField.frame.origin.y-kbSize.height);
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
-(void) scrollToTop{
    [_scrollView setContentOffset:CGPointZero animated:YES];
}
-(void) hideKeyboard{
    [self tapTexts];
}

-(void) tapTexts{
    [currentTextField resignFirstResponder];
}

-(void)tapView:(UITapGestureRecognizer *)recognizer{
    if(currentTextField.isEditing){
        [self tapTexts];
    }
}

-(void) unloadView{
    [self unRegisterKeyboard];
    [_txtCpf unloadView];
    [_txtRepeatPwd unloadView];
    [_txtPwd unloadView];
    
}


-(void) showLoading{
    [self hideKeyboard];
    [_activityIndicator setHidden:NO];
    [_activityIndicator startAnimating];
    [_viewFields setHidden:YES];
    [_viewPassword setHidden:YES];
    [_btSend setHidden:YES];
    [self scrollToTop];
}
-(void) stopLoading{
    [_activityIndicator setHidden:YES];
    [_activityIndicator stopAnimating];
    [_viewFields setHidden:NO];
    [_viewPassword setHidden:NO];
    [_btSend setHidden:NO];
}


-(void) showSuccessMessage{
    [_popupSucess setHidden:NO];
}

-(NSString*) getCPF{

    return [_txtCpf text];
}
-(NSString*) getNewPwd{
    return [_txtPwd text];
}
-(NSString*) getRepatPwd{
    return [_txtRepeatPwd text];
}
-(NSString*) getOldPwd{
    return [_txtOldPwd text];
}

-(void) showCpfError:(NSString*)message{
    [_txtCpf showErrorField:message color:[BaseView getColor:@"Vermelho"]];

}
-(void) showPwdError:(NSString*)message{
    [_txtPwd showErrorField:message color:[BaseView getColor:@"Vermelho"]];

}
-(void) showRepeatPwdError:(NSString*)message{
    [_txtRepeatPwd showErrorField:message color:[BaseView getColor:@"Vermelho"]];

}
-(void) showOldPwdError:(NSString*)message{
    [_txtOldPwd showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
@end
