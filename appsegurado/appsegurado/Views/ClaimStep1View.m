//
//  ClaimStep1View.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 15/11/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ClaimStep1View.h"
@interface ClaimStep1View(){
    UIButton *selectedClaim;
}
@end
@implementation ClaimStep1View

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    [_widthSpace setConstant:self.frame.size.width - 40];
    [_betweenSpace setConstant: 15];
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    /*
     "ClaimOption1" = "Roubo e Furto";
     "ClaimOption2" = "Alagamento";
     "ClaimOption3" = "Acidente";
     "ClaimOption4" = "Acidente sem terceiros";*/
    
    [self configureButton:_btChoice1 title:NSLocalizedString(@"ClaimOption1", @"")];
    [_btChoice1 setTag:30];
    [self configureButton:_btChoice2 title:NSLocalizedString(@"ClaimOption2", @"")];
    [_btChoice2 setTag:50];
    [self configureButton:_btChoice3 title:NSLocalizedString(@"ClaimOption3", @"")];
    [_btChoice3 setTag:10];
//    [self configureButton:_btChoice4 title:NSLocalizedString(@"ClaimOption4", @"")];
//    [_btChoice4 setTag:3];
    
    [_lblTitle setFont:[BaseView getDefatulFont:Medium bold:YES]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    [_lblTitle setTextAlignment:NSTextAlignmentLeft];
    [_lblTitle setText:NSLocalizedString(@"ClaimTitle1", @"")];

    
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


    
    [_btNext setTitle:NSLocalizedString(@"Avancar", @"") forState:UIControlStateNormal];
    [_btNext.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_btNext setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    [_btNext setBorderColor:[BaseView getColor:@"CorBotoes"]];
    [_btNext setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];

    if(![Config isAliroProject]){
        [_btNext setBorderColor:[BaseView getColor:@"Amarelo"]];
        [_btNext setBackgroundColor:[BaseView getColor:@"Amarelo"]];
    }
    
    [BaseView addDropShadow:_bgView];

    [self updateConstraints];

}

-(void) configureButton:(UIButton*)button title:(NSString*)title{
    [button.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
    [button.titleLabel setNumberOfLines:2];
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:[BaseView getColor:@"AzulEscuro"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"select"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"selected"] forState:UIControlStateSelected];
    
}
-(void) unloadView{

    
}

- (IBAction)selectClaimType:(id)sender{
    if(selectedClaim != nil){
        [selectedClaim setSelected:NO];
    }
    selectedClaim = (UIButton*) sender;
    [selectedClaim setSelected:YES];
}

-(int) getSelectedClaim{
    
    return selectedClaim == nil ? -1 : (int) selectedClaim.tag;
}

@end
