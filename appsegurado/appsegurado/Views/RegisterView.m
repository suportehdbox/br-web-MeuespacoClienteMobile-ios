//
//  RegisterView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 29/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "RegisterView.h"

@interface RegisterView(){
    UITextField *currentTextField;
    BOOL isFbUser;
}

@end

@implementation RegisterView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
//    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(_btPrivacy.frame) + 10)];
    //    [_scrollView setFrame:self.frame];
    [_widthView setConstant:CGRectGetMaxX(self.frame)];
//    [self updateConstraintsIfNeeded];
    //    CGRect windowRect = self.window.frame;
    //    if(windowRect.size.height <= 568){
    //        [_spaceBotToBts setConstant:10];
    //        [_spaceBtsToLogin setConstant:10];
    //    }
    
    
    [_groupView1 setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_groupView2 setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_groupView3 setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_groupView4 setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    NSString *instructionsStr = NSLocalizedString(@"InstrucoesCadastro", @"");
    NSMutableAttributedString *instructions = [[NSMutableAttributedString alloc] initWithString:instructionsStr];
    
    [instructions addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:XLarge bold:YES] range:NSMakeRange(0, [instructionsStr length])];
    
    [instructions addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [instructionsStr length])];

    
    instructionsStr = NSLocalizedString(@"InstrucoesCadastro2", @"");
    NSMutableAttributedString *instructions2 = [[NSMutableAttributedString alloc] initWithString:instructionsStr];
    
    [instructions2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:XLarge bold:NO]
                          range:NSMakeRange(0, [instructionsStr length])];
    [instructions2 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [instructionsStr length])];
    

    instructionsStr = NSLocalizedString(@"InstrucoesCadastro3", @"");
    NSMutableAttributedString *instructions3 = [[NSMutableAttributedString alloc] initWithString:instructionsStr];
    
    [instructions3 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [instructionsStr length])];
    [instructions3 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [instructionsStr length])];

    
    NSMutableAttributedString *instructionsFinal = [[NSMutableAttributedString alloc] initWithAttributedString:instructions];
    [instructionsFinal appendAttributedString:instructions2];
    [instructionsFinal appendAttributedString:instructions3];
    [_lblInstructions setAttributedText:instructionsFinal];
    [_lblInstructions setAdjustsFontSizeToFitWidth:YES];
    [_lblInstructions setMinimumScaleFactor:0.3];
    [_lblInstructions setTextAlignment:NSTextAlignmentCenter];
    [_lblInstructions setNumberOfLines:3];
//
//    [_lblPasswordInstruction setAttributedText:instructions];
//    [_lblPasswordInstruction setAdjustsFontSizeToFitWidth:YES];
//    [_lblPasswordInstruction setMinimumScaleFactor:0.3];
//    [_lblPasswordInstruction setNumberOfLines:2];
    
    
    
//    "ApoliceAuto" = "Digite sua apólice ou placa do carro";
//    "ApoliceResidencia" = "Digite sua apólice ou CEP";
//    "ApoliceVida" = "Digite sua apólice ou data de nascimento";
//    "DigiteEmail" = "Digite seu E-mail";
//    "DigiteCPF" = "Digite seu CPF";
//    "DigiteSenha" = "Digite sua senha";
//    "DigiteConfSenha" = "Confirme sua senha";
    
    [_txtName setPlaceholder:NSLocalizedString(@"Nome", @"")];
    [_txtName setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtName setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtName setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtName setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtName setKeyboardType:UIKeyboardTypeDefault];
    [_txtName setDelegate:self];

    [_txtPolicyNumber setPlaceholder:NSLocalizedString(@"ApoliceAuto", @"")];
//    [_txtPolicyNumber set
    [_txtPolicyNumber setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPolicyNumber setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPolicyNumber setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPolicyNumber setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPolicyNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtPolicyNumber setDelegate:self];
    
    [_txtCpf setPlaceholder:NSLocalizedString(@"DigiteCPF", @"")];
    [_txtCpf setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtCpf setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtCpf setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtCpf setDelegate:self];

    
    [_txtEmail setPlaceholder:NSLocalizedString(@"DigiteEmail", @"")];
    [_txtEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmail setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmail setDelegate:self];

//    [_txtRepeatEmail setPlaceholder:NSLocalizedString(@"ConfirmeEmail", @"")];
//    [_txtRepeatEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
//    [_txtRepeatEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtRepeatEmail setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtRepeatEmail setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
//    [_txtRepeatEmail setKeyboardType:UIKeyboardTypeEmailAddress];
//    [_txtRepeatEmail setDelegate:self];
    
    
    [_txtPassword setPlaceholder:NSLocalizedString(@"DigiteSenha", @"")];
    [_txtPassword setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPassword setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPassword setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPassword setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPassword setKeyboardType:UIKeyboardTypeDefault];
    [_txtPassword setSecureTextEntry:YES];
    [_txtPassword setDelegate:self];

    [_txtRepeatPassword setPlaceholder:NSLocalizedString(@"DigiteConfSenha", @"")];
    [_txtRepeatPassword setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtRepeatPassword setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatPassword setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatPassword setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtRepeatPassword setKeyboardType:UIKeyboardTypeDefault];
    [_txtRepeatPassword setSecureTextEntry:YES];
    [_txtRepeatPassword setDelegate:self];
    
    
    [_lblFields setTextAlignment:NSTextAlignmentCenter];
    [_lblFields setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblFields setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_lblFields setText:NSLocalizedString(@"MaisInformacoesCadastro", @"")];
    
    
    [_btLife setTitle:@"" forState:UIControlStateNormal];
    [_btLife setImage:[UIImage imageNamed:@"life_register"] forState:UIControlStateNormal];
    [_btLife setImage:[UIImage imageNamed:@"life_register_on"] forState:UIControlStateSelected];
    [_btAuto setTitle:@"" forState:UIControlStateNormal];
    [_btAuto setImage:[UIImage imageNamed:@"auto_register"] forState:UIControlStateNormal];
    [_btAuto setImage:[UIImage imageNamed:@"auto_register_on"] forState:UIControlStateSelected];
    [_btHome setTitle:@"" forState:UIControlStateNormal];
    [_btHome setImage:[UIImage imageNamed:@"home_register"] forState:UIControlStateNormal];
    [_btHome setImage:[UIImage imageNamed:@"home_register_on"] forState:UIControlStateSelected];
    
    
    if([Config isAliroProject]){
        [_btLife setHidden:YES];
        [_btHome setHidden:YES];
        [_btAuto setHidden:NO];
        [_buttonsHeightConstraints setConstant:0];
        [_policyBoxHeightConstraints setConstant:325];
        [_positionButtonAuto setConstant:self.frame.size.width*0.275f];
    }
    
    [self setAutoPolicy:nil];
    
    NSString *pwd_instructions =NSLocalizedString(@"InstrucoesPassword", @"") ;
    
    NSMutableAttributedString *instructionsPWD = [[NSMutableAttributedString alloc] initWithString:pwd_instructions];
    
    [instructionsPWD addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, [pwd_instructions length])];

    pwd_instructions = NSLocalizedString(@"InstrucoesPassword2", @"");
    NSMutableAttributedString *instructionsPWD2 = [[NSMutableAttributedString alloc] initWithString:pwd_instructions];
    
    [instructionsPWD2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [pwd_instructions length])];
    
    NSMutableAttributedString *instructionPWDFinal = [[NSMutableAttributedString alloc] initWithAttributedString:instructionsPWD];
    [instructionPWDFinal appendAttributedString:instructionsPWD2];
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
//    [instructionPWDFinal addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [instructionPWDFinal length])];
    
    [_lblPasswordInstruction setAttributedText:instructionPWDFinal];
    [_lblPasswordInstruction setAdjustsFontSizeToFitWidth:YES];
    [_lblPasswordInstruction setMinimumScaleFactor:0.5];
    [_lblPasswordInstruction setNumberOfLines:3];

//    [_lblPasswordInstruction setBackgroundColor:[UIColor redColor]];
    
    [_swAgreeTerms setOnTintColor:[BaseView getColor:@"CorBotoes"]];
    [_swAgreeTerms setOn:NO];
    
    [_btRegister setTitle:NSLocalizedString(@"Registrar", @"") forState:UIControlStateNormal];

    [_btRegister setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    if ([Config isAliroProject]) {
        [_btRegister setBorderRound:0];
        [_btRegister setBorderWidth:0];
        [_btRegister setBackgroundColor:[BaseView getColor:@"AzulRegistrar"]];
    }else{
        [_btRegister setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btRegister setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btRegister.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_btRegister setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        
    }
    
    
    NSMutableAttributedString *terms = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@%@", NSLocalizedString(@"TermosCondições", @""),NSLocalizedString(@"TermosCondições2", @"")]];
    [terms addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange([NSLocalizedString(@"TermosCondições", @"") length], [NSLocalizedString(@"TermosCondições2", @"") length])];
    
    [terms addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Nano bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"TermosCondições2", @"") length] + [NSLocalizedString(@"TermosCondições", @"") length])];
    
    [terms addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange([NSLocalizedString(@"TermosCondições", @"") length], [NSLocalizedString(@"TermosCondições2", @"") length])];
    [terms addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange([NSLocalizedString(@"TermosCondições", @"") length], [NSLocalizedString(@"TermosCondições2", @"") length])];
    
    [_btTerms setAttributedTitle:terms forState:UIControlStateNormal];
    [_btTerms.titleLabel setNumberOfLines:2];
    
    
    
    [_activity setHidden:YES];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    [_popupSuccess loadView];
    [_popupSuccess setHidden:YES];
    
}

-(void) loadValuesWith:(FBUserBeans*)user{
    [_txtName setText:user.name];
    [_txtEmail setText:user.email];
    [_txtRepeatEmail setText:user.email];
    
    
    if(user.type == Apple){
        return;
    }
    
    isFbUser = true;
    
    [_pwdBox setHidden:YES];
    [_pwdBoxHeight setConstant:0];
    
    if(user.email != nil && ![user.email isEqualToString:@""]){
        [_groupView2 setHidden:YES];
        [_emailBoxHeight setConstant:0];
    }
    
    [_txtRepeatPassword setHidden:YES];
    [_txtPassword setHidden:YES];
    
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtName){
        [_txtPolicyNumber becomeFirstResponder];
    }else if(textField == _txtPolicyNumber){
        if(isFbUser){
            [_txtCpf setReturnKeyType:UIReturnKeyDone];
        }
        [_txtCpf becomeFirstResponder];
    }else if(textField == _txtCpf){
        if(!isFbUser){
            [_txtEmail becomeFirstResponder];
        }else{
            [_txtCpf resignFirstResponder];
        }
    }else if(textField == _txtEmail){
//        [_txtRepeatEmail becomeFirstResponder];
//    }else if(textField == _txtRepeatEmail){
        if(!isFbUser){
            [_txtPassword becomeFirstResponder];
        }else{
            [_btRegister sendActionsForControlEvents:UIControlEventTouchUpInside];
        }
    }else if(textField == _txtPassword){
        [_txtRepeatPassword becomeFirstResponder];
    }else{
        [_btRegister sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if(textField == _txtPolicyNumber){
        
        int lenght = textField.text.length;
        
        if(_btHome.isSelected){
            if(lenght == 5){
                NSString *cepvalues = [textField.text substringToIndex:5];
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
        }else if(_btAuto.isSelected){
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
        }else{
            NSString *cleanDate = [textField.text stringByReplacingOccurrencesOfString:@"/" withString:@""];
            if(lenght == 2){
                NSString *days = [cleanDate substringToIndex:2];
              
                if([days intValue] <= 31){
                    textField.text = [NSString stringWithFormat:@"%@/",days];
                    if (range.length > 0) {
                        [textField setText:[NSString stringWithFormat:@"%@",days]];
                    }
                }
            }else if(lenght == 5){
                
                NSString *days = [cleanDate substringToIndex:2];
                NSString *mouth = [cleanDate substringFromIndex:2];
                
                if([days intValue] <= 31 && [mouth intValue] <= 12){
                    textField.text = [NSString stringWithFormat:@"%@/%@/",days,mouth];
                    
                    if (range.length > 0) {
                        [textField setText:[NSString stringWithFormat:@"%@/%@",days,mouth]];
                    }
                }else{
                    [textField setText:cleanDate];
                }
            }else {
                if(range.length > 0){
                    return YES;
                }
                if([cleanDate length] >= 8 && [cleanDate length] < 10){
                    [textField setText:cleanDate];
                    return YES;
                }
                if(lenght >= 11 ){
                    return NO;
                }
                
            }
            
        }
        
        int limit = 9;
        return !([textField.text length]>limit && [string length] > range.length);
    }else if(textField == _txtCpf){
        int limit = 13;
        return !([textField.text length]>limit && [string length] > range.length);
    }
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    currentTextField = textField;
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
    [_txtName unloadView];
    [_txtCpf unloadView];
    [_txtEmail unloadView];
    [_txtPassword unloadView];
    [_txtRepeatEmail unloadView];
    [_txtRepeatPassword unloadView];
    [_txtPolicyNumber unloadView];
    
    
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


-(NSString*) getName{
    return @"1";
}
-(NSString*) getPolicyNumber{
    return [_txtPolicyNumber text];
}
-(NSString*) getCpf{
    return [_txtCpf text];
}
-(NSString*) getEmail{
    return [_txtEmail text];
}
-(NSString*) getRepeatEmail{
    return [_txtRepeatEmail text];
}
-(NSString*) getPwd{
    return [_txtPassword text];
}
-(NSString*) getRepeatPwd{
    return [_txtRepeatPassword text];
}

-(int) getTypePolice{
    if(_btAuto.isSelected){
        return 0;
    }else if(_btHome.isSelected){
        return 1;
    }
    return 2;
}

-(BOOL) isTermsAgreed{
    return [_swAgreeTerms isOn];
}


-(void) showNameError:(NSString*)message{
    [self scrollToTop];
    [_txtName showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

-(void) showPolicyError:(NSString*)message{
    [self scrollToTop];
    [_txtPolicyNumber showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showCpfError:(NSString*)message{
    [self scrollToTop];
    [_txtCpf showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showEmailError:(NSString*)message{
    [self scrollToTop];
    [_txtEmail showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showRepeatEmailError:(NSString*)message{
    [self  scrollToTop];
    [_txtRepeatEmail showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showPasswordError:(NSString*)message{
    [_txtPassword showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}
-(void) showRepeatPasswordError:(NSString*)message{
    [_txtRepeatPassword showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

-(void) showSuccessMessage{
    [_popupSuccess setHidden:NO];
}


-(void) showLoading{
    [self tapTexts];
    [_popupSuccess setHidden:YES];
    [_groupView1 setHidden:YES];
    [_groupView2 setHidden:YES];
    [_groupView3 setHidden:YES];
    [_groupView4 setHidden:YES];
    [_activity setHidden:NO];
    [_activity startAnimating];
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void) stopLoading{
    [_groupView1 setHidden:NO];
    [_groupView2 setHidden:NO];
    [_groupView3 setHidden:NO];
    [_groupView4 setHidden:NO];
    [_activity setHidden:YES];
    [_activity stopAnimating];
    
}


-(IBAction)setAutoPolicy:(id)sender{
    [_btAuto setSelected:YES];
    [_btHome setSelected:NO];
    [_btLife setSelected:NO];
    [_txtPolicyNumber setPlaceholder:NSLocalizedString(@"ApoliceAuto", @"")];
    [_txtPolicyNumber setKeyboardType:UIKeyboardTypeDefault];
    [_txtPolicyNumber setText:@""];
}

-(IBAction)setHomePolicy:(id)sender{
    [_btAuto setSelected:NO];
    [_btHome setSelected:YES];
    [_btLife setSelected:NO];
    [_txtPolicyNumber setPlaceholder:NSLocalizedString(@"ApoliceResidencia", @"")];
    [_txtPolicyNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtPolicyNumber setText:@""];
}
-(IBAction)setLifePolicy:(id)sender{
    [_btAuto setSelected:NO];
    [_btHome setSelected:NO];
    [_btLife setSelected:YES];
    [_txtPolicyNumber setPlaceholder:NSLocalizedString(@"ApoliceVida", @"")];
    [_txtPolicyNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [_txtPolicyNumber setText:@""];

}

@end
@implementation RegisterSuccessView

-(void)loadView{
    
    NSString *instructionsStr = NSLocalizedString(@"InstrucoesCadastroSucesso", @"");
    NSMutableParagraphStyle *paragraph = [[NSMutableParagraphStyle alloc] init];
    [paragraph setLineSpacing:5];
    NSMutableAttributedString *instructions = [[NSMutableAttributedString alloc] initWithString:instructionsStr];
    
    [instructions addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Large bold:NO] range:NSMakeRange(0, [instructionsStr length])];
    
    [instructions addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [instructionsStr length])];
    
    
    instructionsStr = NSLocalizedString(@"InstrucoesCadastroSucesso2", @"");
    NSMutableAttributedString *instructions2 = [[NSMutableAttributedString alloc] initWithString:instructionsStr];
    
    [instructions2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO]
                          range:NSMakeRange(0, [instructionsStr length])];
    [instructions2 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [instructionsStr length])];
    
    
    instructionsStr = NSLocalizedString(@"InstrucoesCadastroSucesso3", @"");
    NSMutableAttributedString *instructions3 = [[NSMutableAttributedString alloc] initWithString:instructionsStr];
    
    [instructions3 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Nano bold:NO] range:NSMakeRange(0, [instructionsStr length])];
    [instructions3 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [instructionsStr length])];
    
    
    NSMutableAttributedString *instructionsFinal = [[NSMutableAttributedString alloc] initWithAttributedString:instructions];
    [instructionsFinal appendAttributedString:instructions2];
    [instructionsFinal appendAttributedString:instructions3];
    [instructionsFinal addAttribute:NSParagraphStyleAttributeName value:paragraph range:NSMakeRange(0, [instructionsFinal length])];
    [_lblInstructions setAttributedText:instructionsFinal];
    
    
    [_btOk setBorderRound:7];
    [_btOk setBorderWidth:1];
    [_btOk setBorderColor:[BaseView getColor:NSLocalizedString(@"CinzaEscuro", @"")]];
    [_btOk setBackgroundColor:[UIColor whiteColor] ];
    [_btOk setTitleColor:[BaseView getColor:NSLocalizedString(@"CinzaEscuro", @"")] forState:UIControlStateNormal];
    [_btOk setTitle:NSLocalizedString(@"BtPopUpSucesso", @"") forState:UIControlStateNormal];
    [_btOk reloadCustomization];
    
    if(![Config isAliroProject]){
        [_btOk setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btOk setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btOk setBorderColor:[BaseView getColor:@"Verde"]];
        [_btOk customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];
    }
    
    
    
    NSMutableAttributedString *email1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EmailNotReceived1", @"")];
    [email1 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EmailNotReceived1", @"") length])];
    [email1 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"EmailNotReceived1", @"") length])];
  
    
    NSMutableAttributedString *email = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EmailNotReceived2", @"")];
    [email addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EmailNotReceived2", @"") length])];
    [email addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"EmailNotReceived2", @"") length])];
    [email addAttribute:NSUnderlineColorAttributeName
                    value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"EmailNotReceived2", @"") length])];
    [email addAttribute:NSUnderlineStyleAttributeName
                    value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"EmailNotReceived2", @"") length])];
    
    [email1 appendAttributedString:email];
    
    [_btSendEmail setAttributedTitle:email1 forState:UIControlStateNormal];
    
    
}

@end
