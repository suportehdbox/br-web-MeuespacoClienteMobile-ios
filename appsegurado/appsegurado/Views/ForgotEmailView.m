//
//  ForgotEmailView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 09/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ForgotEmailView.h"
@interface ForgotEmailView(){
    CustomTextField *currentTextField;
    int limitCharacters;
}
@end
@implementation ForgotEmailView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    [_widthBgView setConstant:CGRectGetMaxX(self.frame)- 30];
    [_bottomSpace setConstant:15];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [BaseView addDropShadow:_bgView];
    
    [self stopLoading];
    
//    [_txtEmail setPlaceholder:NSLocalizedString(@"NovoEmail", @"")];
//    [_txtEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
//    [_txtEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
//    [_txtEmail setDelegate:self];
//    
//    
//    [_txtRepeatEmail setPlaceholder:NSLocalizedString(@"ConfirmarNovoEmail", @"")];
//    [_txtRepeatEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
//    [_txtRepeatEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtRepeatEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtRepeatEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtRepeatEmail setKeyboardType:UIKeyboardTypeEmailAddress];
//    [_txtRepeatEmail setSecureTextEntry:NO];
//    [_txtRepeatEmail setDelegate:self];
    
    
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setText:NSLocalizedString(@"TrocarEmail", @"")];

    [_lblSubTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblSubTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblSubTitle setText:@""];
    
    [_lblDescription setFont:[BaseView getDefatulFont:Micro bold:NO]];
    [_lblDescription setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblDescription setText:@""];
    
    [_txtField1 setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtField1 setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtField1 setKeyboardType:UIKeyboardTypeDefault];
    [_txtField1 setDelegate:self];
    
    [_txtField2 setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtField2 setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtField2 setKeyboardType:UIKeyboardTypeDefault];
    [_txtField2 setReturnKeyType:UIReturnKeyDone];
    [_txtField2 setDelegate:self];
    


    
    
    if ([Config isAliroProject]) {
        [_btNext setBorderColor:[BaseView getColor:@"CorBotoes"]];
        [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    }else{
        [_btNext setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btNext.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_btNext setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    
    
    [_imgSteps setContentMode:UIViewContentModeScaleAspectFit];
    
    limitCharacters = 13;
    
//    [_btSend setTitle:NSLocalizedString(@"BtEnviarEmail", @"") forState:UIControlStateNormal];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    
//    [_lblSuccess setFont:[BaseView getDefatulFont:XLarge bold:NO]];
//    [_lblSuccess setTextColor:[BaseView getColor:@"Verde"]];
//    [_lblSuccess setText:NSLocalizedString(@"EmailAlterado", @"")];
//    
//    [_btSucess setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];

}



-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtField1){
        if(![_txtField2 isHidden]){
            [_txtField2 becomeFirstResponder];
        }else{
            [_btNext sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
        
    }else{
        [_btNext sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = (CustomTextField*) textField;
    if(currentTextField == _txtField1){
        if(![_txtField2 isHidden]){
            [_txtField1 setReturnKeyType:UIReturnKeyNext];
        }else{
            [_txtField1 setReturnKeyType:UIReturnKeyNext];
        }
    }
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(limitCharacters > 0){
        int limit = limitCharacters;
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
    [_txtField1 unloadView];
    [_txtField2 unloadView];
    
    
}


-(void) showLoading{
    [self hideKeyboard];
    [_activity setHidden:NO];
    [_activity startAnimating];
    [_bgView setHidden:YES];
    [_btNext setHidden:YES];
    [_imgSteps setHidden:YES];
    [self scrollToTop];
}
-(void) stopLoading{
    
    [_activity stopAnimating];
    [_activity setHidden:YES];
    [_bgView setHidden:NO];
    [_btNext setHidden:NO];
    [_imgSteps setHidden:NO];
}

-(NSString*) getField1{
    return [_txtField1 text];
}
-(void) showField1Error:(NSString*)message{
    [_txtField1 showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(NSString*) getField2{
    return [_txtField2 text];
}
-(void) showField2Error:(NSString*)message{
    [_txtField2 showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

-(void) showRequestCpf{
    [_lblSubTitle setText:NSLocalizedString(@"SubTitutloTrocaEmailCpf",@"")];
    [_lblDescription setText:NSLocalizedString(@"DescTrocaEmailDesloga",@"")];
    [_txtField1 setPlaceholder:NSLocalizedString(@"DigiteSeuCpf", @"")];
    [_txtField2 setHidden:YES];
    [_txtField1 setKeyboardType:UIKeyboardTypeNumberPad];
    [_btNext setTitle:NSLocalizedString(@"Avancar", @"") forState:UIControlStateNormal];
    [_heightView setConstant:240];
    [_imgSteps setImage:[UIImage imageNamed:@"steps_1_4.png"]];
    limitCharacters = 13;
}

-(void) showQuestion:(NSString*) title number:(NSString*)number{
    [_lblSubTitle setText:[NSString stringWithFormat:@"%@. %@",number, title]];
    [_lblDescription setText:NSLocalizedString(@"DescTrocaEmailDesloga",@"")];
    [_txtField1 setText:@""];
    [_txtField1 setPlaceholder:NSLocalizedString(@"DigiteAqui", @"")];
    [_txtField2 setHidden:YES];
    [_txtField1 setKeyboardType:UIKeyboardTypeDefault];
    [_btNext setTitle:NSLocalizedString(@"Avancar", @"") forState:UIControlStateNormal];
    [_heightView setConstant:240];
    [_imgSteps setImage:[UIImage imageNamed:[NSString stringWithFormat:@"steps_%d_4.png",[number intValue] + 1]]];
    
    limitCharacters = 0;
}
-(void) showNewEmailForm{
    [_lblSubTitle setText:NSLocalizedString(@"PreenchaNovoEmail", @"")];
    [_lblDescription setText:@""];
    [_txtField1 setText:@""];
    [_txtField1 setPlaceholder:NSLocalizedString(@"NovoEmail", @"")];
    [_txtField1 setKeyboardType:UIKeyboardTypeEmailAddress];
    
    [_txtField2 setText:@""];
    [_txtField2 setPlaceholder:NSLocalizedString(@"ConfirmarNovoEmail", @"")];
    [_txtField2 setHidden:NO];
    [_txtField2 setKeyboardType:UIKeyboardTypeEmailAddress];

    [_btNext setTitle:NSLocalizedString(@"BtEnviarEmail", @"") forState:UIControlStateNormal];
    [_btNext.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_heightDesc setConstant:0];
    [_heightView setConstant:260];
    [_spaceButton setConstant:0];
    [_widthSteps1 setConstant:0];
    [_widthSteps2 setConstant:0];
    limitCharacters = 0;

}
-(void) showSuccessMessage{
    [_lblSuccess setFont:[BaseView getDefatulFont:Large bold:NO]];
    [_lblSuccess setTextColor:[BaseView getColor:@"Verde"]];
    [_lblSuccess setText:NSLocalizedString(@"EmailAlterado", @"")];
    
    [_btSucess setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    
    if(![Config isAliroProject]){
        [_btSucess setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btSucess setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btSucess setBorderColor:[BaseView getColor:@"Verde"]];
        [_btSucess customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    
    
    [_viewSuccess setHidden:NO];

}


@end
