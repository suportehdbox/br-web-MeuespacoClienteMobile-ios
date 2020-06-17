//
//  PolicyView.m
//  appsegurado
//
//  Created by Luiz othavio H Zenha on 13/10/16.
//  Copyright © 2016 Liberty Seguros. All rights reserved.
//

#import "PolicyView.h"
#import "PolicyViewCell.h"

#import "CustomButton.h"

@interface PolicyView(){
    NSMutableArray * arrayPolices;
    UIActivityIndicatorView *activity;
    BOOL showBtOldPolices;
    BOOL showloadingMorePolices;
}
@end
@implementation PolicyView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
-(void) loadView{
    
    [self setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
    arrayPolices = [[NSMutableArray alloc] init];
    showBtOldPolices = false;
    showloadingMorePolices =YES;
    _heightTitle.constant = 0;
    [_lblTitle setFont:[BaseView getDefatulFont:Small bold:NO]];
    [_lblTitle setTextColor:[BaseView getColor:@"AzulEscuro"]];
    
}




-(void) unloadView{
    
}
-(void) loadPolicies:(NSArray*) array{
//    [arrayPolices removeAllObjects];
    showloadingMorePolices = false;
    if([arrayPolices count] ==0){
        showBtOldPolices = true;
    }
    [arrayPolices addObjectsFromArray:array];
    [_table reloadData];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    int sum = 0;
    if(showBtOldPolices || showloadingMorePolices){
        sum = 1;
    }
    return [arrayPolices count] + sum;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
     return 15;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if(indexPath.section < [arrayPolices count]){
        InsuranceBeans *insurance = (InsuranceBeans*) [arrayPolices objectAtIndex:indexPath.section];
        return 50 + ([insurance.itens count] * 70);
    }else if(showBtOldPolices){
        return 120;
    }else if (showloadingMorePolices) {
        return 60;
    }
    return 100;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 0)];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if(indexPath.section < [arrayPolices count]){
        PolicyViewCell * cell = (PolicyViewCell*) [tableView dequeueReusableCellWithIdentifier:@"PolicyCell"];
     
        InsuranceBeans *insurance = (InsuranceBeans*) [arrayPolices objectAtIndex:indexPath.section];
        
        cell.lblTitlePolicy.text = NSLocalizedString(@"Apolice",@"");
        cell.lblPolicy.text = insurance.policy;
        [cell.lblTitlePolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblTitlePolicy setTextColor:[BaseView getColor:@"AzulEscuro"]];
        [cell.lblPolicy setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.lblPolicy setTextColor:[BaseView getColor:@"CinzaEscuro"]];
        [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        
        
        
        NSArray *viewsToRemove = [cell.viewContainer subviews];
        for (UIView *v in viewsToRemove) {
            [v removeFromSuperview];
        }
//
        float posY = 0;
        float widthImage = CGRectGetWidth(cell.iconPolicy.frame)-1;
        float margin = 5;
        
        
        for (int i = 0; i < [insurance.itens count]; i++) {
            ItemInsurance *item = [insurance.itens objectAtIndex:i];
            
            UIImageView *_iconTypePolicy = [[UIImageView alloc] initWithFrame:CGRectMake(0, posY, widthImage, widthImage)];
            [_iconTypePolicy setImage:[UIImage imageNamed:insurance.branchImageName]];
            [_iconTypePolicy setContentMode:UIViewContentModeScaleAspectFit];
            [cell.viewContainer addSubview:_iconTypePolicy];
            
            UILabel *_lblTypePoliy = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_iconTypePolicy.frame) + (margin * 2), posY, (widthImage*2), widthImage)];
            _lblTypePoliy.text = insurance.branchName;
            [_lblTypePoliy setFont:[BaseView getDefatulFont:Small bold:NO]];
            [_lblTypePoliy setTextColor:[BaseView getColor:@"AzulClaro"]];
            if(![Config isAliroProject]){
                [_lblTypePoliy setTextColor:[BaseView getColor:@"AzulEscuro"]];
            }
            
            _lblTypePoliy.adjustsFontSizeToFitWidth = true;
            _lblTypePoliy.numberOfLines = 1;
            _lblTypePoliy.lineBreakMode = NSLineBreakByTruncatingTail;
            [cell.viewContainer addSubview:_lblTypePoliy];
            
            float posXDesc = CGRectGetMaxX(_lblTypePoliy.frame) + (margin * 2);
            UILabel *_lblPolicyDescription = [[UILabel alloc] initWithFrame:CGRectMake(posXDesc, posY, CGRectGetWidth(self.frame)/2 - 10, (widthImage * 2.5f) )];
            _lblPolicyDescription.numberOfLines = 3;
            _lblPolicyDescription.lineBreakMode = NSLineBreakByTruncatingTail;
            _lblPolicyDescription.text = [NSString stringWithFormat:@"%@",item.desc];
            _lblPolicyDescription.adjustsFontSizeToFitWidth = true;
            
            [_lblPolicyDescription setFont:[BaseView getDefatulFont:Small bold:NO]];
            
            [_lblPolicyDescription setTextColor:[BaseView getColor:@"CinzaEscuro"]];
            [cell.viewContainer addSubview:_lblPolicyDescription];
            
            posY = CGRectGetMaxY(_lblPolicyDescription.frame);
            posY += margin;
        }

        [BaseView addDropShadow:cell.bgView];
        return cell;
    }else if(showBtOldPolices){
        PolicyViewCell * cell = (PolicyViewCell*) [tableView dequeueReusableCellWithIdentifier:@"PolicyEndCell"];
        [cell.btLoadOldPolices setHidden:NO];
        [cell.activity setHidden:YES];
        [cell.btLoadOldPolices setEnabled:YES];
        [cell.btLoadOldPolices setBorderWidth:1];
        [cell.btLoadOldPolices setBorderColor:[BaseView getColor:@"CorBotoes"]];
        [cell.btLoadOldPolices setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        [cell.btLoadOldPolices.titleLabel setFont:[BaseView getDefatulFont:Small bold:NO]];
        [cell.btLoadOldPolices setTitleColor:[BaseView getColor:@"CorBotoes"] forState:UIControlStateNormal];
        [cell.btLoadOldPolices setTitle:NSLocalizedString(@"ApolicesAntigas", @"") forState:UIControlStateNormal];
        [cell.btLoadOldPolices reloadCustomization];
        
        [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        
        return cell;
    }else if (showloadingMorePolices) {
        PolicyViewCell * cell = (PolicyViewCell*) [tableView dequeueReusableCellWithIdentifier:@"PolicyEndCell"];
        [cell.btLoadOldPolices setHidden:YES];
        [cell.activity startAnimating];
        [cell.activity setHidden:NO];
        [cell setBackgroundColor:[BaseView getColor:@"CinzaFundo"]];
        return cell;
    }
    return [[UITableViewCell alloc] initWithFrame:CGRectZero];
}
-(InsuranceBeans*) getInsuranceClickedAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.section < [arrayPolices count]){
        return (InsuranceBeans*) [arrayPolices objectAtIndex:indexPath.section];
    }else{
        return nil;
    }
}

-(void) showButonOldPolices:(BOOL)show{
    showBtOldPolices = show;
    [_table reloadData];
}
-(void) showLoadingMorePolices{
    [self showButonOldPolices:NO];
    showloadingMorePolices =true;
    [_table reloadData];
}
-(void) setTitleTable:(NSString*)text{
    [_lblTitle setText:text];
    [_heightTitle setConstant:60];
    
}
@end
