//
//  ClubView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 04/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClubView.h"
@interface ClubView (){
    UIActivityIndicatorView *activiy;
}
@end
@implementation ClubView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void) loadView{
    [_widthScroll setConstant:self.frame.size.width-30];
    [_betweenButtonSpace setConstant:15];
    
    [self.webView setUserInteractionEnabled:YES];
    [self.webView setOpaque:YES];
    [self.webView setScalesPageToFit:YES];
    [_webView setDelegate:self];
    

    
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"DescClub",@"")];
    [desc addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, desc.length)];
    [desc addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, desc.length)];
    [_lblTitle setText:@""];
    [_lblDescription setAttributedText:desc];
    [_btAccess setTitle:NSLocalizedString(@"BtClub", @"") forState:UIControlStateNormal];
    [_btAccess setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
    [_btAccess.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btLogin setHidden:YES];
    
    if(![Config isAliroProject]){
        [_btAccess setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btAccess setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        
    }

}

-(void) loadOffView{
    [_widthScroll setConstant:self.frame.size.width-30];
    [_betweenButtonSpace setConstant:65];
    [self updateConstraints];
    [self.webView setUserInteractionEnabled:YES];
    [self.webView setOpaque:NO];
    [self.webView setScalesPageToFit:YES];
    
    NSMutableAttributedString *title = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"TituloClub",@"")];
    [title addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, title.length)];
    [title addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:[NSLocalizedString(@"TituloClub",@"") rangeOfString:NSLocalizedString(@"TituloClubBold1",@"")]];
    [title addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:[NSLocalizedString(@"TituloClub",@"") rangeOfString:NSLocalizedString(@"TituloClubBold2",@"")]];
    
    NSMutableAttributedString *desc = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"DescClubOff",@"")];
    [desc addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:[NSLocalizedString(@"DescClubOff",@"") rangeOfString:NSLocalizedString(@"DescClubOff",@"")]];
    [desc addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, desc.length)];
    
    NSMutableAttributedString *desc2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"DescClubOff2",@"")];
    [desc2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, desc2.length)];
    [desc2 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, desc2.length)];
    
    
    [desc appendAttributedString:desc2];
    /*"DescClubOff" = "São descontos e benefícios em lojas online e em estabelecimentos parceiros de todo o país.";
     "DescClubOff2" = "\nPara desfrutar dos nossos benefícios, basta ser Cliente Liberty Seguros. E o melhor: não é preciso acumular pontos, nem pagar mais nada por isso!";
     //DescClubOff22
     "DescClubOff3" = "\n\nPara ter acesso ao Clube Liberty, faça login ou cadastr-se e aproveite todos os benefícios exclusivos:";
     "DescClubOffBold1" = "faça login";
     "DescClubOffBold2" = "cadastre-se";
     */
    NSMutableAttributedString * finalText = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"DescClubOff3",@"")];
    
    [finalText addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO]range:NSMakeRange(0, finalText.length)];
    

    
    [finalText addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:[NSLocalizedString(@"DescClubOff3",@"") rangeOfString:NSLocalizedString(@"DescClubOffBold1",@"")]];
    
    [finalText addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:[NSLocalizedString(@"DescClubOff3",@"") rangeOfString:NSLocalizedString(@"DescClubOffBold2",@"")]];

    [finalText addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, finalText.length)];
    
    [desc appendAttributedString:finalText];
    [_lblTitle setAttributedText:title];
    [_lblDescription setAttributedText:desc];

    [_btAccess.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btAccess customizeBackground:[BaseView getColor:@"Branco"]];
    [_btAccess setTitleColor:[BaseView getColor:@"AzulLogin"] forState:UIControlStateNormal ];
    [_btAccess setTitle:NSLocalizedString(@"Cadastrar", @"") forState:UIControlStateNormal ];
    [_btAccess customizeBorderColor:[BaseView getColor:@"AzulLogin"] borderWidth:1 borderRadius:7];
    
    [_btLogin setHidden:NO];
    [_btLogin.titleLabel setFont:[BaseView getDefatulFont:Small bold:false]];
    [_btLogin customizeBackground:[BaseView getColor:@"AzulLogin"]];
    [_btLogin setTitle:NSLocalizedString(@"Logar", @"") forState:UIControlStateNormal ];
    [_btLogin customizeBorderColor:[BaseView getColor:@"AzulLogin"] borderWidth:1 borderRadius:7];

    if (![Config isAliroProject]) {
        [_btLogin setBackgroundColor:[BaseView getColor:@"Amarelo"]];
        [_btLogin setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btLogin customizeBorderColor:[BaseView getColor:@"Amarelo"] borderWidth:1 borderRadius:7];
        [_btLogin setTitleColor:[BaseView getColor:@"AzulLogin"] forState:UIControlStateNormal];
        [_btAccess setBackgroundColor:[BaseView getColor:@"Verde"]];
        [_btAccess setBorderColor:[BaseView getColor:@"Verde"]];
        [_btAccess customizeBorderColor:[BaseView getColor:@"Verde"] borderWidth:1 borderRadius:7];

    }
    
    
}
-(void) updateClubImage:(UIImage*) image{
    [_imgView setImage:image];
    
}
-(void)webViewDidStartLoad:(UIWebView *)webView{
    if(activiy == nil){
        activiy = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activiy setCenter:self.center];
        [self addSubview:activiy];
    }
    [activiy startAnimating];
    [activiy setHidden:NO];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [activiy stopAnimating];
    [activiy setHidden:YES];
}

-(void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    [super showMessage:NSLocalizedString(@"ErrorTitle",@"") message:error.localizedDescription];
    [activiy stopAnimating];
    [activiy setHidden:YES];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"URL %@", [[request URL] absoluteString]);
    if (navigationType == UIWebViewNavigationTypeLinkClicked && [[[request URL] absoluteString]  containsString:@"#extenal"]) {
       
        if([[[UIDevice currentDevice] systemVersion] integerValue] < 10){
          [[UIApplication sharedApplication] openURL:[request URL]];
        }else{
            UIApplication *application = [UIApplication sharedApplication];
            [application openURL:[request URL] options:@{} completionHandler:nil];
        }
        return NO;
    }
    
    return YES;
}

-(void) loadRequest:(NSURLRequest*) request{
    [_webView loadRequest: request];
    
    [_viewDescription setHidden:YES];
    [_webView setHidden:NO];
}
@end
