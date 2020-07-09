//
//  LoginView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 26/09/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "LoginView.h"


@interface LoginView(){
    UITapGestureRecognizer *tap;
}
@end
@implementation LoginView
@synthesize btLoginLater, btGoogle;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView:(LoginViewController*)controller{
    
    if (@available(iOS 13.0, *)) {
        ASAuthorizationAppleIDButton *btApple = [[ASAuthorizationAppleIDButton alloc] initWithAuthorizationButtonType:ASAuthorizationAppleIDButtonTypeSignIn authorizationButtonStyle:ASAuthorizationAppleIDButtonStyleBlack];
        [btApple setFrame:CGRectZero];
        [btApple addTarget:controller action:@selector(loginAppleClick:) forControlEvents:UIControlEventTouchUpInside];
        [btApple setContentHorizontalAlignment: UIControlContentHorizontalAlignmentLeft];
        
        [btApple setCornerRadius:0];
        
        [_viewBtApple addSubview:btApple];
        btApple.translatesAutoresizingMaskIntoConstraints = false;
        
        [btApple.leadingAnchor constraintEqualToAnchor:_viewBtApple.leadingAnchor constant:0].active = true;
        [btApple.trailingAnchor constraintEqualToAnchor:_viewBtApple.trailingAnchor constant:0].active = true;
        [btApple.topAnchor constraintEqualToAnchor:_viewBtApple.topAnchor constant:0].active = true;
        [btApple.bottomAnchor constraintEqualToAnchor:_viewBtApple.bottomAnchor constant:0].active = true;
        [BaseView addDropShadow:_viewBtApple];
        
        [self updateConstraints];
    } else {
        // Fallback on earlier versions
        [_viewBtApple setHidden:YES];
    }
    
    
    
    if([Config isAliroProject]){
        [_imgLogoLiberty setImage:[UIImage imageNamed:@"logo_login"]];
        [_imgLogoLiberty setContentMode:UIViewContentModeScaleAspectFit];
    }
    
//    [_scrollView setFrame:self.frame];
    [_widthImage setConstant:CGRectGetMaxX(self.frame)];
    [self updateConstraintsIfNeeded];
    [_scrollView setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
//    CGRect windowRect = self.window.frame;
//    if(windowRect.size.height <= 568){
//        [_spaceBotToBts setConstant:10];
//        [_spaceBtsToLogin setConstant:10];
//    }
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
    
    
    [_btLoginFacebook setTitle:NSLocalizedString(@"LoginFacebook", @"") forState:UIControlStateNormal];
    [_btLoginFacebook setBorderRound:0];
    [_btLoginFacebook setNoRounedEffect];
    [_btLoginFacebook customizeBorderColor:0 borderWidth:0 borderRadius:0];
    [_btLoginFacebook customizeBackground:[UIColor colorWithRed:0.259f green:0.404f blue:0.698f alpha:1]];
    [BaseView addDropShadow:_btLoginFacebook];
    [_btLoginFacebook updateConstraints];
    
//    _btGoogle = [[GIDSignInButton alloc] initWithFrame:_btGoogle.frame];
    [btGoogle setColorScheme:kGIDSignInButtonColorSchemeLight];
    
    [btGoogle setStyle:kGIDSignInButtonStyleWide];
    
//    [_btGoogle setUserInteractionEnabled:YES];
//    [_btGoogle sendActionsForControlEvents:UIControlEventTouchUpInside];
//    [_btGoogle addTarget:target action:@selector(googleSiginClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [_lblOr setText:NSLocalizedString(@"Ou", @"")];
    [_lblOr setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblOr setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    [_txtEmailCpf setPlaceholder:NSLocalizedString(@"EmailCpf", @"")];
    [_txtEmailCpf setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtEmailCpf setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmailCpf setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmailCpf setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtEmailCpf setKeyboardType:UIKeyboardTypeEmailAddress];
    [_txtEmailCpf setDelegate:self];
    
    [_txtPassword setPlaceholder:NSLocalizedString(@"Senha", @"")];
    [_txtPassword setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_txtPassword setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPassword setPlaceholderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPassword setBottomBorderColor:[BaseView getColor:@"CinzaEscuro"]];
    [_txtPassword setKeyboardType:UIKeyboardTypeDefault];
    [_txtPassword setDelegate:self];
    
    [_swLogado setOnTintColor:[BaseView getColor:@"CorBotoes"]];
    [_lblSwitch setText:NSLocalizedString(@"ManterLogado", @"")];
    [_lblSwitch setFont:[BaseView getDefatulFont:Nano bold:NO]];
    [_lblSwitch setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    
    if ([Config isAliroProject]) {
        [_btLogin setTitle:NSLocalizedString(@"Entrar", @"") forState:UIControlStateNormal];
        [_btLogin setBorderColor:[BaseView getColor:@"CorBotoes"]];
        [_btLogin setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_btLogin setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    }else{
        [_btLogin setTitle:NSLocalizedString(@"Entrar", @"") forState:UIControlStateNormal];
        [_btLogin setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btLogin setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [_btLogin setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        
    }
    
    
    
    NSMutableAttributedString *forgetPassword = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EsqueceuSenha", @"")];
    [forgetPassword addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulLogin"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenha", @"") length])];
    [forgetPassword addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenha", @"") length])];
    [forgetPassword addAttribute:NSUnderlineColorAttributeName
                  value:[BaseView getColor:@"AzulLogin"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenha", @"") length])];
    [forgetPassword addAttribute:NSUnderlineStyleAttributeName
                  value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuSenha", @"") length])];

    [_btForgetPassword setAttributedTitle:forgetPassword forState:UIControlStateNormal];
    
    NSMutableAttributedString *forgetPasswordSelected = [[NSMutableAttributedString alloc] initWithAttributedString:forgetPassword];
    [forgetPasswordSelected addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [forgetPassword length])];
    [forgetPasswordSelected addAttribute:NSUnderlineColorAttributeName
                           value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [forgetPassword length])];
    [_btForgetPassword setAttributedTitle:forgetPasswordSelected forState:UIControlStateHighlighted];

    
    
    
    
    NSMutableAttributedString *forgetEmail = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"EsqueceuEmail", @"")];

    [forgetEmail addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulLogin"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuEmail", @"") length])];
    [forgetEmail addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuEmail", @"") length])];
    [forgetEmail addAttribute:NSUnderlineColorAttributeName
                           value:[BaseView getColor:@"AzulLogin"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuEmail", @"") length])];
    [forgetEmail addAttribute:NSUnderlineStyleAttributeName
                           value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuEmail", @"") length])];
    
    [_btForgetEmail setAttributedTitle:forgetEmail forState:UIControlStateNormal];
    NSMutableAttributedString *forgetSelected = [[NSMutableAttributedString alloc] initWithAttributedString:forgetEmail];
    [forgetSelected addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuEmail", @"") length])];
    [forgetSelected addAttribute:NSUnderlineColorAttributeName
                        value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [NSLocalizedString(@"EsqueceuEmail", @"") length])];
    [_btForgetEmail setAttributedTitle:forgetSelected forState:UIControlStateHighlighted];
//    [_btForgetEmail setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
    
    
    NSMutableAttributedString *registerTxt = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"FraseCadastrar", @"")];
    
    [registerTxt addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrar", @"") length])];
    [registerTxt addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"FraseCadastrar", @"") length])];
    
    
    
    
    NSRange rangeRegister = [NSLocalizedString(@"FraseCadastrar", @"") rangeOfString:@"?"];
    
    rangeRegister.length = [NSLocalizedString(@"FraseCadastrar", @"")  length] - rangeRegister.location - 2;
    rangeRegister.location +=2;
    
    [registerTxt addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulLogin"] range:rangeRegister];
    [registerTxt addAttribute:NSUnderlineColorAttributeName
                        value:[BaseView getColor:@"AzulLogin"] range:rangeRegister];
    [registerTxt addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:rangeRegister];

    
    [_btRegister setAttributedTitle:registerTxt forState:UIControlStateNormal];
    
    NSMutableAttributedString *registerSelected = [[NSMutableAttributedString alloc] initWithAttributedString:registerTxt];
    [registerSelected addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [registerTxt length])];
    [registerSelected addAttribute:NSUnderlineColorAttributeName
                            value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [registerTxt length])];
    [_btRegister setAttributedTitle:registerSelected forState:UIControlStateHighlighted];

    
    
    
    
    NSMutableAttributedString *privacy = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Politica", @"")];
    [privacy addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulLogin"] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    [privacy addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Nano bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    [privacy addAttribute:NSUnderlineColorAttributeName
                        value:[BaseView getColor:@"AzulLogin"] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    [privacy addAttribute:NSUnderlineStyleAttributeName
                        value:[NSNumber numberWithInt:NSUnderlineStyleSingle] range:NSMakeRange(0, [NSLocalizedString(@"Politica", @"") length])];
    
  
    
    [_btPrivacy setAttributedTitle:privacy forState:UIControlStateNormal];
    
    
    NSMutableAttributedString *privacySelected = [[NSMutableAttributedString alloc] initWithAttributedString:privacy];
    [privacySelected addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [privacy length])];
    [privacySelected addAttribute:NSUnderlineColorAttributeName
                                   value:[BaseView getColor:@"CinzaClaro"] range:NSMakeRange(0, [privacy length])];
    [_btPrivacy setAttributedTitle:privacySelected forState:UIControlStateHighlighted];
    
    [_swLogado setOn:YES];
    [_swLogado setHidden:YES];
    [_lblSwitch setHidden:YES];
    
//
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
//    [self addGestureRecognizer:tap];
    [self registerForKeyboardNotifications];
    
    
    
//    [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(adjustScreen) userInfo:nil repeats:NO];
    
}

-(void) adjustScreen{
    [_scrollView setContentSize:CGSizeMake(self.frame.size.width, CGRectGetMaxY(_btPrivacy.frame)+15)];
   
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    if(textField == _txtEmailCpf){
        [_txtPassword becomeFirstResponder];
    }else{
        [_btLogin sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    return true;
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
    if(_txtEmailCpf.isEditing){
        currentText = _txtEmailCpf;
    }else if(_txtPassword.isEditing){
        currentText = _txtPassword;
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
    
    if(!tap){
        tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
        [self addGestureRecognizer:tap];
        
    }
}


// Called when the UIKeyboardWillHideNotification is sent
- (void)keyboardWillBeHidden:(NSNotification*)aNotification
{
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    _scrollView.contentInset = contentInsets;
    _scrollView.scrollIndicatorInsets = contentInsets;
    [self removeGestureRecognizer:tap];
    tap = nil;
}

-(void) hideKeyboard{
    [self tapTexts];
}

-(void) tapTexts{
    if(_txtEmailCpf.isEditing){
        [_txtEmailCpf resignFirstResponder];
    }else if(_txtPassword.isEditing){
        [_txtPassword resignFirstResponder];
    }
}

-(BOOL)tapView:(UITapGestureRecognizer *)recognizer{

    
    if(_txtEmailCpf.isEditing || _txtPassword.isEditing){
        [self tapTexts];
    }
    return true;
}

-(void) unloadView{
    [self unRegisterKeyboard];
    [_txtEmailCpf unloadView];
    [_txtPassword unloadView];
    [[NSNotificationCenter defaultCenter] removeObserver:_txtEmailCpf];
    [[NSNotificationCenter defaultCenter] removeObserver:_txtPassword];

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


-(NSString*) getEmailCPF{
    return [_txtEmailCpf text];
}

-(void) showEmailCPFError:(NSString*)message{
    [_txtEmailCpf showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

-(NSString*) getPwd{
    return [_txtPassword text];
}

-(BOOL) shouldStayLogged{
    return [_swLogado isOn];
}
-(void) showPwdError:(NSString*)message{
    [_txtPassword showErrorField:message color:[BaseView getColor:@"Vermelho"]];
}

-(void) showLoading{
    [_lblTouchId setHidden:YES];
    [_lblOr setHidden:YES];
    [_lblSwitch setHidden:YES];
    [_txtEmailCpf setHidden:YES];
    [_txtPassword setHidden:YES];
    [_btLogin setHidden:YES];
    [_btLoginFacebook setHidden:YES];
    [_btRegister setHidden:YES];
    [_btPrivacy setHidden:YES];
    [_btForgetEmail setHidden:YES];
    [_btForgetPassword setHidden:YES];
    [btLoginLater setHidden:YES];
    [_swLogado setHidden:YES];
    [_acitivty setHidden:NO];
    [btGoogle setHidden:YES];
    [_viewBtApple setHidden:YES];
    [_acitivty startAnimating];
    
    [_scrollView setContentOffset:CGPointZero animated:YES];
}

-(void) stopLoading{
    [_lblTouchId setHidden:NO];
    [_lblOr setHidden:NO];
//    [_lblSwitch setHidden:NO];
    [_txtEmailCpf setHidden:NO];
    [_txtPassword setHidden:NO];
    [_btLogin setHidden:NO];
    [_btLoginFacebook setHidden:NO];
    [_btRegister setHidden:NO];
    [_btPrivacy setHidden:NO];
    [_btForgetEmail setHidden:NO];
    [_btForgetPassword setHidden:NO];
    [btLoginLater setHidden:NO];
    [btGoogle setHidden:NO];
    [_viewBtApple setHidden:NO];
//    [_swLogado setHidden:NO];
    [_acitivty setHidden:YES];
    [_acitivty stopAnimating];

}

-(void) cleanPassword{
    [_txtPassword setText:@""];
}

@end
