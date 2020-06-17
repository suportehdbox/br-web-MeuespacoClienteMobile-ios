//
//  ContactView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 12/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "ContactView.h"
#import "ContactTableViewCell.h"
#import "AgentContactViewCell.h"
#import "ContactBeans.h"
@interface ContactView () {
    NSMutableArray *arrayPhones;
    ContactBeans * contCapital;
    ContactBeans * contOthers;
    ContactBeans * contAssistAuto;
    ContactBeans * contAssistHome;
    BOOL shouldAssistFirst;
    BOOL loadingContacts;
    int ordering;
    int orderingHeight;
}
@end
@implementation ContactView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{

    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    arrayPhones = [[NSMutableArray alloc] init];
    contCapital = [[ContactBeans alloc] init];
    [contCapital setTitle:NSLocalizedString(@"CapitalContactTitle",@"")];
    [contCapital setPhone:NSLocalizedString(@"CapitalContactPhone",@"")];
    [contCapital setHours:NSLocalizedString(@"CapitalContactHours",@"")];
    
    
    contOthers = [[ContactBeans alloc] init];
    [contOthers setTitle:NSLocalizedString(@"OthersContactTitle",@"")];
    [contOthers setPhone:NSLocalizedString(@"OthersContactPhone",@"")];
    [contOthers setHours:NSLocalizedString(@"OthersContactHours",@"")];
    
    
    
    contAssistAuto = [[ContactBeans alloc] init];
    [contAssistAuto setTitle:NSLocalizedString(@"AssistAutoContactTitle",@"")];
    [contAssistAuto setPhone:NSLocalizedString(@"AssistAutoContactPhone",@"")];
    
    contAssistHome = [[ContactBeans alloc] init];
    [contAssistHome setTitle:NSLocalizedString(@"AssistResContactTitle",@"")];
    [contAssistHome setPhone:NSLocalizedString(@"AssistResContactPhone",@"")];
    
    shouldAssistFirst = false;
    ordering = 0;
}

-(void) loadAgentsPhone:(NSArray*) array{
    loadingContacts = false;
    [arrayPhones addObjectsFromArray:array];
    ordering = 0;
    shouldAssistFirst = !shouldAssistFirst;
    [_table reloadData];
}

-(void) setAssistFirst:(BOOL)yesNo{
    shouldAssistFirst = yesNo;
}

-(void) unloadView{

}

-(void) setLoading:(BOOL) loading{
    loadingContacts = loading;
    if(!loading){
        ordering = 0;
        shouldAssistFirst = !shouldAssistFirst;
        [_table reloadData];
    }
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return [arrayPhones count] + 2;
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if(section == 0 && loadingContacts){
        
       UIView  * view  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 75)];
        UIActivityIndicatorView *activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [activity setCenter:view.center];
        [activity startAnimating];
        [view addSubview:activity];
        return view;
    }
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
     if(indexPath.section < [arrayPhones count]){
         ContactBeans *agent = [arrayPhones objectAtIndex:indexPath.section];
         NSArray *arraypolicy = [agent.policy componentsSeparatedByString:@","];
        return 160 + (20 + ( 10 * [arraypolicy count] / 2));
    }else{
        if(shouldAssistFirst) {
            
           
            if(indexPath.section < [arrayPhones count]+1){
                return 250;
            }
        }else{
            if(indexPath.section == [arrayPhones count]+1){
                return 250;
            }
        }
    }
    if([contAssistHome.title isEqualToString:@""]){
        return 80;
    }
    return 170;
    
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(section == 0 && loadingContacts){
        return 75;
    }
    return 15;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < [arrayPhones count]){
        
        AgentContactViewCell * cell = (AgentContactViewCell*) [tableView dequeueReusableCellWithIdentifier:@"AgentContactCell"];
        ContactBeans *agent = [arrayPhones objectAtIndex:indexPath.section];
        cell.lblTitle.text = agent.title;
        [cell.lblTitle setFont:[BaseView getDefatulFont:Medium bold:NO]];
        [cell.lblTitle  setNumberOfLines:2];
        [cell.lblTitle setTextColor:[BaseView getColor:@"AzulClaro"]];
        [cell.lblPolicy setText:[NSString stringWithFormat:NSLocalizedString(@"ApoliceNum",@""),agent.policy]];
        NSArray *arraypolicy = [agent.policy componentsSeparatedByString:@","];
        [cell.heightPolicy setConstant:(20 + ( 10 * [arraypolicy count] / 2))];
        [cell.lblPolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblPolicy  setNumberOfLines: ceil([arraypolicy count] / 2)];
        [cell.lblPolicy setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell.btPhone setTitle:agent.phone forState:UIControlStateNormal];
        [cell.btPhone.titleLabel setFont:[BaseView getDefatulFont:Large bold:YES]];
        [cell.btPhone.titleLabel setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell.btMail setTitle:agent.email forState:UIControlStateNormal];
        [cell.btMail.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.btMail.titleLabel setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        [BaseView addDropShadow:cell.bgView];
        return cell;
    }else{
        if(indexPath.section == [arrayPhones count] && ordering != 0){
            ordering = 0;
            shouldAssistFirst = !shouldAssistFirst;
        }
        
        ContactTableViewCell * cell = (ContactTableViewCell*) [tableView dequeueReusableCellWithIdentifier:@"ContactCell"];
        
        if(shouldAssistFirst){
            
            NSMutableAttributedString *assistAuto = [[NSMutableAttributedString alloc] initWithString:contAssistAuto.title];
            [assistAuto addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [contAssistAuto.title length])];
            NSRange rangeBold = [contAssistAuto.title rangeOfString:NSLocalizedString(@"AssistBoldText", @"")];
            [assistAuto addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:rangeBold];
            [cell.lblTitle setAttributedText:assistAuto];
            [cell.btPhone setTitle:contAssistAuto.phone forState:UIControlStateNormal];
            
            if(![contAssistHome.title isEqualToString:@""]){
                NSMutableAttributedString *assistHome = [[NSMutableAttributedString alloc] initWithString:contAssistHome.title];
                [assistHome addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [contAssistHome.title length])];
                NSRange rangeHomeBold = [contAssistAuto.title rangeOfString:NSLocalizedString(@"AssistBoldText", @"")];
                [assistHome addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:rangeHomeBold];
                [cell.lblTitle2 setAttributedText:assistHome];
                [cell.btPhone2 setTitle:contAssistHome.phone forState:UIControlStateNormal];
            }else{
                [cell.lblTitle2 setHidden:YES];
                [cell.divisor setHidden:YES];
                [cell.btPhone2 setHidden:YES];
            }
         
            
            [cell.lblTitle setTextColor:[BaseView getColor:@"Verde"]];
            [cell.lblTitle2 setTextColor:[BaseView getColor:@"Verde"]];
            [cell.heightHours setConstant:0];
            [cell.heightHours2 setConstant:0];
            [cell.btSkype setHidden:YES];
            [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
            [cell setFrame:CGRectMake(cell.frame.origin.x, cell.frame.origin.y, cell.frame.size.width, 170)];
            [BaseView addDropShadow:cell.bgView];
            
        }else{
            cell.lblTitle.text = contCapital.title;
            [cell.btPhone setTitle:contCapital.phone forState:UIControlStateNormal];
            cell.lblHours.text = contCapital.hours;
            cell.lblTitle2.text = contOthers.title;
            [cell.btPhone2 setTitle:contOthers.phone forState:UIControlStateNormal];
            cell.lblHours2.text = contOthers.hours;
            
            [cell.lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
            [cell.lblTitle2 setTextColor:[BaseView getColor:@"AzulEscuro"]];
            [cell.lblTitle setFont:[BaseView getDefatulFont:Micro bold:YES]];
            [cell.lblTitle2 setFont:[BaseView getDefatulFont:Micro bold:YES]];
            
            NSMutableAttributedString *skype1 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Skype1", @"")];
            [skype1 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:NO] range:NSMakeRange(0, [NSLocalizedString(@"Skype1", @"") length])];
            [skype1 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, [NSLocalizedString(@"Skype1", @"") length])];
            
            NSMutableAttributedString *skype2 = [[NSMutableAttributedString alloc] initWithString:NSLocalizedString(@"Skype2", @"")];
            [skype2 addAttribute:NSFontAttributeName value:[BaseView getDefatulFont:Micro bold:YES] range:NSMakeRange(0, [NSLocalizedString(@"Skype2", @"") length])];
            [skype2 addAttribute:NSForegroundColorAttributeName value:[BaseView getColor:@"Verde"] range:NSMakeRange(0, [NSLocalizedString(@"Skype2", @"") length])];
            
//            NSTextAttachment *textAttachment = [[NSTextAttachment alloc] init];
//            textAttachment.image = [UIImage imageNamed:@"skype.png"];
//            
             NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:@""];
//            NSAttributedString *attrStringWithImage = [NSAttributedString attributedStringWithAttachment:textAttachment];
            
//            [attributedString appendAttributedString:attrStringWithImage];
            [attributedString appendAttributedString:skype1];
            [attributedString appendAttributedString:skype2];
            
            [cell.btSkype setImage:[UIImage imageNamed:@"skype.png"] forState:UIControlStateNormal];
            [cell.btSkype setAttributedTitle:attributedString forState:UIControlStateNormal];
            [cell.btSkype setHidden:NO];
            [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
            [BaseView addDropShadow:cell.bgView];
        }
        
        if(ordering == 0){
            shouldAssistFirst = !shouldAssistFirst;
        }
        
        ordering++;
        
        [cell.btPhone.titleLabel setFont:[BaseView getDefatulFont:Large bold:YES]];
        [cell.btPhone2.titleLabel setFont:[BaseView getDefatulFont:Large bold:YES]];
        [cell.lblHours setFont:[BaseView getDefatulFont:Nano bold:NO]];
        [cell.lblHours2 setFont:[BaseView getDefatulFont:Nano bold:NO]];
        [cell.lblHours setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell.lblHours2 setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        
        return cell;
    }

}
@end
