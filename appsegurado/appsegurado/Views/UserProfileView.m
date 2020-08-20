//
//  UserProfileView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 06/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "UserProfileView.h"
#import "UserOptionsTableViewCell.h"
@interface UserProfileView(){

    NSMutableArray *arrayOptions;
}
@end
@implementation UserProfileView
@synthesize btGoogle;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    //Meus Dados
    [_loading setHidden:YES];
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    
    arrayOptions = [[NSMutableArray alloc] init];
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_key",@"icon",NSLocalizedString(@"TrocarSenha",@""), @"title", @"ChangePassword",@"destination", nil]];
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_mail",@"icon",NSLocalizedString(@"TrocarEmail",@""), @"title", @"ChangeEmail",@"destination", nil]];
    
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_smartphone",@"icon",NSLocalizedString(@"UpdatePhone",@""), @"title",@"ChangePhone",@"destination",nil]];
    
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_docs",@"icon",NSLocalizedString(@"MeusDocumentos",@""), @"title", @"MeusDocumentos",@"destination", nil]];
//    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_eye",@"icon",NSLocalizedString(@"VisualizarCartao",@""), @"title", @"",@"destination", nil]];
    
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_phone",@"icon",NSLocalizedString(@"FaleConosco",@""), @"title",@"ShowContact",@"destination", nil]];
    
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_lgpd_app",@"icon",NSLocalizedString(@"TratamentoDados",@""), @"title",@"ShowTratamentoDados",@"destination", nil]];
    
    [arrayOptions addObject:[[NSDictionary alloc] initWithObjectsAndKeys:@"icon_exit",@"icon",NSLocalizedString(@"Sair",@""), @"title",@"dismiss",@"destination", nil]];
    
    
    [_btFacebook setTitle:NSLocalizedString(@"LinkarFacebook", @"") forState:UIControlStateNormal];
    
    [btGoogle setColorScheme:kGIDSignInButtonColorSchemeDark];
    
    [BaseView addDropShadow:_viewMenu];
    
//    if ([ [ UIScreen mainScreen ] bounds ].size.height < 568){
//        [_bottonMargin setConstant:20];
//    }else{
//
//        [_bottonMargin setConstant: (CGRectGetMaxY(self.frame) - CGRectGetMaxY(_viewMenu.frame))/3];
//    }
}

-(void) loadViewAfterAppeared{
    [_userView loadView];
}
-(void) unloadView{


}

-(int) numberOfRows{

    return  (int)[arrayOptions count];
}

-(NSString*) getSegueAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary * dic = [arrayOptions objectAtIndex:indexPath.row];
    return [dic objectForKey:@"destination"];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UserOptionsTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"OptionCell"];
    NSDictionary * dic = [arrayOptions objectAtIndex:indexPath.row];
    [[cell lblTitle] setText:[dic objectForKey:@"title"]];
    if(![[dic objectForKey:@"icon"] isEqualToString:@""]){
        [[cell imgOption] setImage:[UIImage imageNamed:[dic objectForKey:@"icon"]] ];
    }
    if(indexPath.row == [arrayOptions count] -1){
        [[cell divisor] setHidden:YES];
    }else{
        [[cell divisor] setHidden:NO];
    }
    
    return cell;
    
}

-(void) googleLinked{
    [btGoogle setHidden:YES];
    [_loading setHidden:YES];
}

-(void) facebookLinked{
    [_btFacebook setHidden:YES];
    [_loading setHidden:YES];
    [_bottonMargin setConstant:-35];
    
}

-(void) showLoadingFacebook:(BOOL) loading{
    [_btFacebook setHidden:loading];
    [btGoogle setHidden:loading];
    [_loading setHidden:YES];
    [_loading setHidden:!loading];
    [_loading startAnimating];
}
@end
