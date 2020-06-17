//
//  UserInfoView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 07/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "UserInfoView.h"
#import "BaseView.h"
#import "AppDelegate.h"
#import "UIImageView+Letters.h"
@implementation UserInfoView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    UserBeans * beans = [appDelegate getLoggeduser];
    
    [self.lblName setText:beans.userName];
    [self.lblName setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [self.lblName setFont:[BaseView getDefatulFont:Small bold:NO]];
    [self.lblEmail setText:beans.emailCpf];
    [self.lblEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
    [self.lblEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    if(beans.photoImg == nil){
        [self.imgPhoto setImageWithString:[beans.userName substringToIndex:1]  color:[BaseView getColor:@"AzulEscuro"] circular:NO ];
    }else{
        [self.imgPhoto setImage:beans.photoImg];
    }
    
    [self.imgPhoto.layer setCornerRadius:28];
    self.imgPhoto.clipsToBounds = YES;
    [BaseView addDropShadow:self];

}
-(void) loadViewHome{
    AppDelegate *appDelegate = (AppDelegate*) [[UIApplication sharedApplication] delegate];
    UserBeans * beans = [appDelegate getLoggeduser];
    
    NSMutableAttributedString *text1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"BemVindo",@"")];
    [text1 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:YES] range:NSMakeRange(0, [text1 length])];
    [text1 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"AzulEscuro"] range:NSMakeRange(0, [text1 length])];
    
    NSMutableAttributedString *text2 = [[NSMutableAttributedString alloc] initWithString:beans.userName];
    [text2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Small bold:NO] range:NSMakeRange(0, [text2 length])];
    [text2 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"CinzaEscuro"] range:NSMakeRange(0, [text2 length])];
    
    NSMutableAttributedString *final = [[NSMutableAttributedString alloc] initWithAttributedString:text1];
    [final appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    [final appendAttributedString:text2];
    
    if([Config isAliroProject]){
        NSMutableAttributedString *text3 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"DesejaFazer",@"")];
        [text3 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Medium bold:NO] range:NSMakeRange(0, [text3 length])];
        [text3 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"TextoDestaque"] range:NSMakeRange(0, [text3 length])];
        
        NSMutableParagraphStyle *paragraf = [[NSMutableParagraphStyle alloc] init];
        [paragraf setParagraphSpacingBefore:5];
        
        [text3 addAttribute:NSParagraphStyleAttributeName value:paragraf range:NSMakeRange(0, [text3 length])];
        [final appendAttributedString:text3];
    }

    
    
    [self.lblMsg setNumberOfLines:0];
    [self.lblMsg setAttributedText:final];
//
//    [self.lblName setText:NSLocalizedString(@"BemVindo",@"")];
//    [self.lblName setTextColor:[BaseView getColor:@"AzulEscuro"]];
//    [self.lblName setFont:[BaseView getDefatulFont:Small bold:NO]];
//    [self.lblEmail setText:beans.userName];
//    [self.lblEmail setTextColor:[BaseView getColor:@"CinzaEscuro"]];
//    [self.lblEmail setFont:[BaseView getDefatulFont:Small bold:NO]];
    
    if(beans.photoImg == nil){
        [self.imgPhoto setImageWithString:[beans.userName substringToIndex:1]  color:[BaseView getColor:@"AzulEscuro"] circular:NO ];
    }else{
        [self.imgPhoto setImage:beans.photoImg];
    }
    
    [self.imgPhoto.layer setCornerRadius:28];
    self.imgPhoto.clipsToBounds = YES;
//    [BaseView addDropShadow:self];
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    if([Config isAliroProject]){
        [BaseView addDropShadow:self];
        [self setBackgroundColor:[BaseView getColor:@"Branco"]];
    }
    
    
}

@end
