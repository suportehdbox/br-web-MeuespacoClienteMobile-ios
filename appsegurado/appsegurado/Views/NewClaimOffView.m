//
//  NewClaimOffView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 28/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "NewClaimOffView.h"
@interface NewClaimOffView(){
    UITextField *currentTextField;
}
@end
@implementation NewClaimOffView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


-(void) loadView:(bool) isAssist24hs{
    [_widthBox setConstant:CGRectGetMaxX(self.frame)- 40];
    [_heightScrollView setConstant:25];
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
   
    [self stopLoading];


    
    [_txtPlatePolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPlatePolicy setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPlatePolicy setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPlatePolicy setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPlatePolicy setKeyboardType:UIKeyboardTypeDefault];
    [_txtPlatePolicy setDelegate:self];
    
    
    [_txtCPF setPlaceholder:NSLocalizedString(@"CPF", @"")];
    [_txtCPF setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtCPF setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCPF setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCPF setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCPF setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtCPF setSecureTextEntry:NO];
    [_txtCPF setDelegate:self];
    
    
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setText:NSLocalizedString(@"DigiteDadosAbaixo", @"")];
  
    if(isAssist24hs){
        [_txtPlatePolicy setPlaceholder:NSLocalizedString(@"VehicleLicense", @"")];
        [_lblTitle setText:NSLocalizedString(@"DigiteDadosAssistencia", @"")];
        [_btStartClaim setTitle:NSLocalizedString(@"IniciarAssistencia", @"") forState:UIControlStateNormal];
    }else{
        [_txtPlatePolicy setPlaceholder:NSLocalizedString(@"PlacaOuApólice", @"")];
        [_lblTitle setText:NSLocalizedString(@"DigiteDadosAbaixo", @"")];
        [_btStartClaim setTitle:NSLocalizedString(@"BtStartClaim", @"") forState:UIControlStateNormal];
    }
    
    [_btStartClaim.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btStartClaim setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
    [_btStartClaim customizeBackground:[BaseView getColor:@"CinzaFundo"]];
    [_btStartClaim customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];

    
    
    
    [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btLogin customizeBackground:[BaseView getColor:@"CorBotoes"]];
    [_btLogin setTitle:NSLocalizedString(@"Logar", @"") forState:UIControlStateNormal ];
    [_btLogin setTitleColor:[BaseView getColor:@"Branco"] forState:UIControlStateNormal];
    [_btLogin customizeBorderColor:[BaseView getColor:@"CorBotoes"] borderWidth:1 borderRadius:7];
    

    [_lblOr setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblOr setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblOr setText:NSLocalizedString(@"Ou", @"")];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    
    NSMutableAttributedString *title1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EstouComDuvidas", @"")];
    
    [title1 addAttribute:NSForegroundColorAttributeName
                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EstouComDuvidas", @"") length])];
    
    
    //    [_btDoubts setTintColor:[BaseView getColor:@"AzulEscuro"]];
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FaleComLiberty", @"")];
    
    [title addAttribute:NSForegroundColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    
    [title addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    [title addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"FaleComLiberty", @"") length])];
    
    [title1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [title1 appendAttributedString:title];
    
    [_btDoubts setAttributedTitle:title1 forState:UIControlStateNormal];
    [_btDoubts.titleLabel setFont:[BaseView getDefatulFont:Micro bold:NO]];

    
    
    NSMutableAttributedString *titleForgot1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EsqueceuSenhaClaim1", @"")];
    
    [titleForgot1 addAttribute:NSForegroundColorAttributeName
                   value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenhaClaim1", @"") length])];

    NSMutableAttributedString *titleForgot2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EsqueceuSenhaClaim2", @"")];
    
    [titleForgot2 addAttribute:NSForegroundColorAttributeName
                  value:[BaseView getColor:@"AzulClaro"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenhaClaim2", @"") length])];
    
    [titleForgot2 addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulClaro"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenhaClaim2", @"") length])];
    [titleForgot2 addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenhaClaim2", @"") length])];
    
    [titleForgot1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [titleForgot1 appendAttributedString:titleForgot2];
    
    [_btForgotPassword setAttributedTitle:titleForgot1 forState:UIControlStateNormal];
    [_btForgotPassword.titleLabel setFont:[BaseView getDefatulFont:Micro bold:NO]];

    
    
    
    
    NSMutableAttributedString *titleRegister1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FraseCadastrarClaim1", @"")];
    
    [titleRegister1 addAttribute:NSForegroundColorAttributeName
                         value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrarClaim1", @"") length])];
    
    NSMutableAttributedString *titleRegister2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FraseCadastrarClaim2", @"")];
    
    [titleRegister2 addAttribute:NSForegroundColorAttributeName
                         value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrarClaim2", @"") length])];
    
    [titleRegister2 addAttribute:NSUnderlineColorAttributeName
                         value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrarClaim2", @"") length])];
    [titleRegister2 addAttribute:NSUnderlineStyleAttributeName
                         value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrarClaim2", @"") length])];
    
    [titleRegister1 appendAttributedString:[[NSMutableAttributedString alloc] initWithString:@" "]];
    [titleRegister1 appendAttributedString:titleRegister2];
    
    [_btRegister setAttributedTitle:titleRegister1 forState:UIControlStateNormal];
    [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Micro bold:NO]];
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtPlatePolicy){
        [_txtCPF becomeFirstResponder];
    }else{
        [_btStartClaim sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField =textField;
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{

    int lenght = textField.text.length;
    if(textField == _txtPlatePolicy){
            if(lenght == 3){
                NSString *cepvalues = [textField.text substringToIndex:3];
                textField.text = [NSString stringWithFormat:@"%@-",cepvalues];
                if (range.length > 0) {
                    [textField setText:cepvalues];
                }
            }
            if(lenght > 9){
                if (range.length <= 0) {
                    NSString *cleanString = [textField.text stringByReplacingOccurrencesOfString:@"-" withString:@""];
                    textField.text = cleanString;
                }
            }
        int limit = 14;
        return !([textField.text length]>limit && [string length] > range.length);
    }else if(textField == _txtCPF){
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
        [_scrollView setContentOffset:scrollPoint animated:YES];
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
    [_txtCPF unloadView];
    [_txtPlatePolicy unloadView];

}
-(NSString*) getPlatePolicy{
    return [_txtPlatePolicy text];
}
-(NSString*) getCpf{
    return [_txtCPF text];
}
-(void) showPlatePolicyError:(NSString*)message{
    [_txtPlatePolicy showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showCPFError:(NSString*)message{
    [_txtCPF showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showLoading{

}
-(void) stopLoading{

}
@end
